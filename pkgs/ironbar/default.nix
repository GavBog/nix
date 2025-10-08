{
  pkgs,
}:
let
  config = builtins.path {
    name = "ironbar-config";
    path = ./config;
  };
in
pkgs.symlinkJoin {
  name = "ironbar-wrapped";
  paths = [ pkgs.ironbar ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/ironbar \
      --set XDG_CONFIG_HOME "${config}"
  '';
}
