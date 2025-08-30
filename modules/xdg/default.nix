{ pkgs, ... }:
let
  kdeConfig = builtins.path {
    name = "kde-config";
    path = ./config/kde;
  };
  configs = pkgs.symlinkJoin {
    name = "xdg-config";
    paths = [ kdeConfig ];
  };
in
{
  environment.extraInit = ''
    export XDG_CONFIG_DIRS="${configs}:''${XDG_CONFIG_DIRS}:${configs}"
  '';
}
