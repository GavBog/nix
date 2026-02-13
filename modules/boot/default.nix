{ ... }:
{
  boot = {
    plymouth.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };

  hardware.graphics.enable = true;
}
