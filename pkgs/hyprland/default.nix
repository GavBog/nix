{
  pkgs,
}:
let
  configPath = builtins.path {
    name = "hyprland-configuration";
    path = ./config;
  };
in
pkgs.symlinkJoin {
  name = "hyprland-wrapped";
  version = pkgs.hyprland.version;
  passthru = pkgs.hyprland.passthru;

  paths = [ pkgs.hyprland ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/Hyprland" \
      --add-flags "-c ${configPath}"
  '';
}
