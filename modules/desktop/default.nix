{ pkgs, customPkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${customPkgs.dwl}/bin/dwl-start";
        user = "greeter";
      };
    };
  };
}
