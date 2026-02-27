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
    impala
    bluetui
    brightnessctl
    age
    age-plugin-yubikey
    ssh-to-age
    sops
    pinentry-curses
    swaybg
    mosh
    clang
    dwl
    dwlb
    someblocks
    fastfetch
    ffmpeg
    fzf
    gh
    ghostty
    git
    gparted
    librewolf
    maliit-framework
    maliit-keyboard
    mergiraf
    nvim
    obsidian
    btop
    kdePackages.dolphin
    stremio
    impactor
    prismlauncher
    vesktop
    tldr
    wl-clipboard
    wmenu
    zoxide
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

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
