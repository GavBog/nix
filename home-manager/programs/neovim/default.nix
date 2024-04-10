{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    # Set System Configurations
    defaultEditor = true;

    # Add Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Add Lua Configurations
  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}

