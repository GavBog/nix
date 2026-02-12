{ ... }:
{
  boot = {
    plymouth.enable = true;
    initrd.systemd.enable = true;
    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };

  hardware.graphics.enable = true;
}
