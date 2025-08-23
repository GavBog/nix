{
  environment.extraInit = ''
    export XDG_CONFIG_DIRS="/etc/xdg:''${XDG_CONFIG_DIRS}:/etc/xdg"
  '';

  environment.etc."xdg/kdeglobals".source = ./config/kde/kdeglobals;
  environment.etc."xdg/kcminputrc".source = ./config/kde/kcminputrc;
  environment.etc."xdg/kwinrc".source = ./config/kde/kwinrc;
}
