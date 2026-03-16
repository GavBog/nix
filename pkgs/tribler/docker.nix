{
  pkgs,
  customPkgs,
  triblerConfTemplate ? ./triblerConfig.json.tmpl,
  caddyConf ? ./Caddyfile,
}:
pkgs.dockerTools.buildLayeredImage {
  name = "tribler";
  tag = "latest";
  contents = [
    customPkgs.tribler
    pkgs.caddy
    pkgs.socat
    pkgs.gettext
    pkgs.bash
    pkgs.coreutils
  ];

  config = {
    Env = [
      "HOME=/data"
      "LANG=C.UTF-8"
      "QT_QPA_PLATFORM=offscreen"
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"

      "USER=user"
      "HASHED_PASSWORD=replace-me"

      "EXTERNAL_IP=0.0.0.0"
      "IPV8_INT_PORT=8090"
      "LIBTORRENT_INT_PORT=20456"
      "IPV8_EXT_PORT=8090"
      "LIBTORRENT_EXT_PORT=20456"
    ];
    ExposedPorts = {
      "8080/tcp" = { }; # Caddy Proxied API
      "8090/udp" = { }; # Discovery
      "20456/tcp" = { }; # Data Transfer
      "20456/udp" = { }; # Data Transfer (uTP)
    };
    Entrypoint = [
      "${pkgs.tini}/bin/tini"
      "--"
    ];
    Cmd = [
      "${pkgs.writeShellScript "entrypoint" ''
        mkdir -p /data/.Tribler/8.0/ /data/Downloads
        if [ "$LIBTORRENT_INT_PORT" != "$LIBTORRENT_EXT_PORT" ]; then
          socat TCP4-LISTEN:$LIBTORRENT_INT_PORT,fork,reuseaddr TCP4:127.0.0.1:$LIBTORRENT_EXT_PORT &
          socat UDP4-LISTEN:$LIBTORRENT_INT_PORT,fork,reuseaddr UDP4:127.0.0.1:$LIBTORRENT_EXT_PORT &
        fi

        if [ "$IPV8_INT_PORT" != "$IPV8_EXT_PORT" ]; then
          socat UDP4-LISTEN:$IPV8_INT_PORT,fork,reuseaddr UDP4:127.0.0.1:$IPV8_EXT_PORT &
        fi

        envsubst < ${triblerConfTemplate} > /data/.Tribler/8.0/configuration.json

        tribler --server --log-level INFO &
        exec caddy run --config ${caddyConf} --adapter caddyfile
      ''}"
    ];
  };
}
