{ pkgs, customPkgs, ... }:
{
  programs.nix-index-database.comma.enable = true;

  environment.systemPackages = with pkgs // customPkgs; [
    bluetuith
    brightnessctl
    clang
    dwl
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
    prismlauncher
    rustup
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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
