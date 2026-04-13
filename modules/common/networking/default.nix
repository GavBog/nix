{ ... }:
{
  services.cloudflare-warp.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/504119
  networking.firewall.checkReversePath = "loose";

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
