{ pkgs, ... }: {
  imports =
    # Import nixos-apple-silicon using fetchTarball since this is a standalone
    # configuration. If using flakes, just add it to inputs.
    let
      nixos-apple-silicon = fetchTarball {
        url =
          "https://github.com/tpwrules/nixos-apple-silicon/archive/refs/tags/release-2024-12-25.tar.gz";
        sha256 = "01sxbqq97fm2m152llgx3bvp2xsfw2zv41bflzx5r8l0r13grabb";
      };
    in [
      (toString nixos-apple-silicon + "/apple-silicon-support")
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
    setupAsahiSound = false;
    peripheralFirmwareDirectory = ./firmware;
    withRust = true;
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

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

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
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    iosevka
  ];

  environment.systemPackages = with pkgs; [
    asahi-bless # reboot to macOS
    git
    gparted
    maliit-framework
    maliit-keyboard
    micro
    alacritty
    librewolf
  ];

  system.stateVersion = "24.11";
}
