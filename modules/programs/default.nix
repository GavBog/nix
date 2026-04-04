{ pkgs, customPkgs, ... }:
{
  programs.nix-index-database.comma.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs // customPkgs; [
    age
    age-plugin-yubikey
    bluetui
    brightnessctl
    btop
    clang
    dwl
    dwlb
    fastfetch
    ffmpeg
    fzf
    gh
    ghostty
    git
    gparted
    impactor
    impala
    kdePackages.dolphin
    librewolf
    maliit-framework
    maliit-keyboard
    mergiraf
    mosh
    nvim
    obsidian
    pinentry-curses
    prismlauncher
    rustup
    someblocks
    sops
    ssh-to-age
    stremio-linux-shell
    swaybg
    tldr
    vesktop
    wl-clipboard
    wmenu
    zoxide
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
    EDITOR = "nvim";
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
