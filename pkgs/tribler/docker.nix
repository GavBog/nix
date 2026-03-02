{
  pkgs,
  triblerConfTemplate ? ./triblerConfig.json.tmpl,
  caddyConf ? ./Caddyfile,
}:
pkgs.dockerTools.buildLayeredImage {
  name = "tribler";
  tag = "latest";
  contents = [
    pkgs.tribler
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
        # export LIBTORRENT_EXT_PORT=
        # export IPV8_EXT_PORT=
        # socat TCP4-LISTEN:$LIBTORRENT_INT_PORT,fork,reuseaddr TCP4:127.0.0.1:$LIBTORRENT_EXT_PORT &
        # socat UDP4-LISTEN:$LIBTORRENT_INT_PORT,fork,reuseaddr UDP4:127.0.0.1:$LIBTORRENT_EXT_PORT &
        # socat UDP4-LISTEN:$IPV8_INT_PORT,fork,reuseaddr UDP4:127.0.0.1:$IPV8_EXT_PORT &

        envsubst < ${triblerConfTemplate} > /data/.Tribler/8.0/configuration.json

        tribler --server &
        exec caddy run --config ${caddyConf} --adapter caddyfile
      ''}"
    ];
  };
}
