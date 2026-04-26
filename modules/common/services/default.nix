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

  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  virtualisation.podman.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  time.timeZone = "America/New_York";
}
