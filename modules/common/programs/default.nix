{
  pkgs,
  customPkgs,
  inputs,
  ...
}:
{
  programs.nix-index-database.comma.enable = true;
  programs.fuse = {
    enable = true;
    userAllowOther = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  environment.systemPackages =
    with pkgs // customPkgs;
    [
      age
      age-plugin-yubikey
      bluetui
      brightnessctl
      btop
      caligula
      clang
      dix
      dwl
      dwlb
      fastfetch
      ffmpeg
      fzf
      gh
      ghostty
      git
      gparted
      impala
      kdePackages.dolphin
      librewolf
      maliit-framework
      maliit-keyboard
      mergiraf
      mosh
      mpv
      nix-output-monitor
      nixos-anywhere
      nvim
      obsidian
      pinentry-curses
      prismlauncher
      qbittorrent
      rust-bindgen
      rustup
      someblocks
      sops
      ssh-to-age
      sshfs
      swaybg
      tldr
      vesktop
      webtorrent_desktop
      wl-clipboard
      wmenu
      yazi
      zoxide
    ]
    ++ [
      inputs.iloader.packages.${stdenv.hostPlatform.system}.default
    ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  environment.sessionVariables = {
    PATH = [ "$HOME/.cargo/bin" ];
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
