{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  btrfsOptions = [
    "compress-force=zstd"
    "noatime"
    "ssd"
    "discard=async"
  ];
in
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

  fileSystems."/" = {
    options = lib.mkForce (
      [
        "subvol=@"
      ]
      ++ btrfsOptions
    );
  };

  fileSystems."/nix" = {
    options = lib.mkForce (
      [
        "subvol=@nix"
      ]
      ++ btrfsOptions
    );
  };

  fileSystems."/home" = {
    options = lib.mkForce (
      [
        "subvol=@home"
      ]
      ++ btrfsOptions
    );
  };

  environment.systemPackages = with pkgs; [
    asahi-bless
  ];

  system.stateVersion = "25.11";
}
