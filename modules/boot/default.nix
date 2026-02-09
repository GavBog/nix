{ ... }:
{
  boot = {
    plymouth.enable = true;
    binfmt.emulatedSystems = [ "x86_64-linux" ];
  };

  hardware.graphics.enable = true;
}
