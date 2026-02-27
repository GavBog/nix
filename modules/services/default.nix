{ pkgs, ... }:
{
  services.openssh.enable = true;
  services.cloudflare-warp.enable = true;
  services.usbmuxd.enable = true;
  services.dbus.implementation = "broker";
  services.scx.package = {
    enable = true;
    package = pkgs.scx.rustscheds.overrideAttrs (old: {
      meta = old.meta or { } // {
        badPlatforms = [ ];
      };
    });
    scheduler = "scx_rustland";
  };
  services.resolved.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  time.timeZone = "America/New_York";
}
