{
  pkgs,
  triblerConf ? ./triblerConfig.json,
  caddyConf ? ./Caddyfile,
}:
pkgs.dockerTools.buildLayeredImage {
  name = "tribler";
  tag = "latest";
  contents = [
    pkgs.tribler
    pkgs.caddy
    pkgs.bash
    pkgs.coreutils
  ];

  config = {
    Env = [
      "HOME=/data"
      "LANG=C.UTF-8"
      "QT_QPA_PLATFORM=offscreen"
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
        cp ${triblerConf} /data/.Tribler/8.0/configuration.json

        tribler --server &
        exec caddy run --config ${caddyConf} --adapter caddyfile
      ''}"
    ];
  };
}
