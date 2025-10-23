{ customPkgs, ... }:
{
  services.displayManager.sessionPackages = [
    customPkgs.dwl
  ];
  services.displayManager.ly.enable = true;
}
