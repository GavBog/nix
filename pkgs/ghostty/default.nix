{
  pkgs,
  configFile ? ./config,
}:
pkgs.symlinkJoin {
  name = "ghostty-wrapped";
  paths = [ pkgs.ghostty ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/ghostty \
      --add-flags "--config-file=${configFile}"
  '';
}
