{ stablePkgs, ... }:
{
  services.cloudflare-warp = {
    enable = true;
    package = stablePkgs.cloudflare-warp;
  };
  services.resolved.enable = true;
  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };
}
