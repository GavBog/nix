{ ... }:
{
  boot = {
    plymouth.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
  };

  image.modules.iso = {
    isoImage.squashfsCompression = "zstd -Xcompression-level 6";
  };

  hardware.graphics.enable = true;
}
