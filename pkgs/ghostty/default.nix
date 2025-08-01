{
  pkgs,
  configFile ? ./config,
}:
pkgs.symlinkJoin {
  name = "ghostty-wrapped";
  paths = [pkgs.ghostty];
  nativeBuildInputs = [pkgs.makeWrapper];

  postBuild = ''
    mkdir -p $out/etc/ghostty
    cp ${configFile} $out/etc/ghostty/config

    wrapProgram $out/bin/ghostty \
      --add-flags "--config-file=$out/etc/ghostty/config"
  '';
}
