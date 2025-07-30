{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixos-apple-silicon.nixosModules.default
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;

    plymouth.enable = true;

    extraModprobeConfig = ''
      options hid_apple swap_fn_leftctrl=1
    '';

    kernelModules = [ "uinput" ];

    initrd.availableKernelModules = [ "xhci_pci" "usb_storage" "usbhid" ];
  };

  hardware.asahi = {
    experimentalGPUInstallMode = "replace";
    useExperimentalGPUDriver = true;
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  hardware.uinput.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  nix.settings = {
    warn-dirty = false;
    experimental-features = [ "nix-command" "flakes" ];
  };

  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  users.users.gavbog = {
    initialPassword = "gavbog";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.groups.uinput = { };

  services.openssh.enable = true;
  services.libinput.touchpad.naturalScrolling = false;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [ "input" "uinput" ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          # Replace the paths below with the appropriate device paths for your setup.
          # Use `ls /dev/input/by-path/` to find your keyboard devices.
          "/dev/input/by-path/platform-23510c000.spi-cs-0-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            caps
          )

          (defalias
            escctrl (tap-hold 150 150 esc lctrl)
          )

          (deflayer base
            @escctrl
          )
        '';
      };
    };
  };

  environment.shellAliases = {
    c = "clear";
    nv = "nvim";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  environment.systemPackages = with pkgs; [
    asahi-bless # reboot to macOS
    git
    gparted
    maliit-framework
    maliit-keyboard
    librewolf
    fastfetch
    gh
    ghostty
  ];

  system.stateVersion = "25.05";
}
