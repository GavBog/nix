{ pkgs, ... }:
{
  services.openssh.enable = true;
  services.cloudflare-warp.enable = true;
  services.usbmuxd.enable = true;
  services.dbus.implementation = "broker";
  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds.overrideAttrs (old: {
      cargoBuildFlags = [ "-p scx_bpfland" ];
      cargoTestFlags = [ "-p scx_bpfland" ];
      meta = old.meta or { } // {
        badPlatforms = [ ];
      };
    });
    scheduler = "scx_bpfland";
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
