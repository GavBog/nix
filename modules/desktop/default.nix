{ pkgs, customPkgs, ... }:
{
  environment.etc."dwl-start".source = "${customPkgs.dwl}/bin/dwl-start";
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
