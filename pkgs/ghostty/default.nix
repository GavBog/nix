{
  pkgs,
  configFile ? ./config,
}:
pkgs.symlinkJoin {
  name = "ghostty-wrapped";
  paths = [ pkgs.ghostty ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    cfg="$out/etc/ghostty"
    mkdir -p $cfg
    cp ${configFile} $cfg/config

    wrapProgram $out/bin/ghostty \
      --add-flags "--config-file=$cfg/config"
  '';
}
