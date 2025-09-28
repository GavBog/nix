{
  inputs,
  pkgs,
  customPkgs,
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

    plymouth.enable = true;

    extraModprobeConfig = ''
      options hid_apple swap_fn_leftctrl=1
    '';

    kernelModules = [ "uinput" ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "usb_storage"
      "usbhid"
    ];
  };

  hardware.graphics.enable = true;
  hardware.asahi = {
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 50;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "bredr";
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  hardware.uinput.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  nix.settings = {
    warn-dirty = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

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
  users.defaultUserShell = customPkgs.zsh;
  users.groups.uinput = { };

  services.openssh.enable = true;
  services.cloudflare-warp.enable = true;

  services.xserver.enable = true;
  services.displayManager.sessionPackages = [
    customPkgs.dwl
  ];
  services.desktopManager.plasma6.enable = true;
  services.displayManager.ly.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
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
            escctrl (tap-hold 200 200 esc lctrl)
          )

          (deflayer base
            @escctrl
          )
        '';
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  # https://github.com/NixOS/nixpkgs/issues/437992
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  environment.shells = [ customPkgs.zsh ];
  programs.nix-index-database.comma.enable = true;
  environment.systemPackages = with pkgs // customPkgs; [
    asahi-bless # reboot to macOS
    git
    gparted
    maliit-framework
    maliit-keyboard
    librewolf
    fastfetch
    gh
    ghostty
    stremio
    wl-clipboard
    zoxide
    fzf
    tldr
    rustup
    clang
    kdePackages.krohnkite
    kdePackages.kconfig
    prismlauncher
    ffmpeg
    wmenu
    ironbar
    dwl
    mergiraf
  ];

  time.timeZone = "America/New_York";
  system.stateVersion = "25.11";
}
