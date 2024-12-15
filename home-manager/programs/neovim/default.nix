{ inputs, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    # Set System Configurations
    defaultEditor = true;

    # Add Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  # Add Lua Configurations
  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}

