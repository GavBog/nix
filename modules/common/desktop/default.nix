{
  pkgs,
  customPkgs,
  config,
  ...
}:
let
  dwl = customPkgs.dwl.override {
    wallpaper = "/run/current_wallpaper";
  };
in
{
  sops.secrets.wallpaper = {
    format = "binary";
    sopsFile = ../../../assets/sunpaper.sops.jpg;
    mode = "0444";
  };

  system.activationScripts.wallpaper-fallback = ''
    if [ ! -f "${config.sops.secrets.wallpaper.path}" ]; then
      ln -sf ${../../../assets/wallpaper.svg} /run/current_wallpaper
    else
      ln -sf ${config.sops.secrets.wallpaper.path} /run/current_wallpaper
    fi
  '';

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    wlr.settings = {
      screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
    };
  };

  programs.uwsm.enable = true;
  environment.etc."dwl-start".source = "${dwl}/bin/dwl-start";
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd /etc/dwl-start";
        user = "greeter";
      };
    };
  };
}
