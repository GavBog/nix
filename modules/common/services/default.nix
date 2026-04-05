{ pkgs, ... }:
{
  services.openssh.enable = true;
  services.usbmuxd.enable = true;
  services.dbus.implementation = "broker";
  services.irqbalance.enable = true;
  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds.overrideAttrs (old: {
      postInstall = "";
      doInstallCheck = false;
      cargoBuildFlags = [
        "-p"
        "scx_bpfland"
      ];
      cargoTestFlags = [
        "-p"
        "scx_bpfland"
      ];
      meta = old.meta or { } // {
        badPlatforms = [ ];
      };
    });
    scheduler = "scx_bpfland";
  };

  virtualisation.podman.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  time.timeZone = "America/New_York";
}
