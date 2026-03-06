{ pkgs, ... }:
{
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = false;

  environment.systemPackages = with pkgs; [
    power-profiles-daemon
  ];
}
