{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;

    extraModprobeConfig = ''
      options hid_apple swap_fn_leftctrl=1
    '';

    initrd.availableKernelModules = [
      "xhci_pci"
      "usb_storage"
      "usbhid"
    ];
  };

  hardware.asahi = {
    setupAsahiSound = false;
    peripheralFirmwareDirectory = ./firmware;
  };

  environment.systemPackages = with pkgs; [
    asahi-bless
  ];

  system.stateVersion = "25.11";
}
