{
  pkgs,
  customPkgs,
  config,
  ...
}:
let
  dwl = customPkgs.dwl.override {
    wallpaper = config.sops.secrets.wallpaper.path or ../../assets/wallpaper.svg;
  };
in
{
  sops.secrets.wallpaper = {
    format = "binary";
    sopsFile = ../../assets/sunpaper.sops.jpg;
    mode = "0444";
  };

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
