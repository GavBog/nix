<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-white.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg">
  <img alt="NixOS Logo" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" width="75" align="right">
</picture>

# gavbog's NixOS Configuration

My personal NixOS setup, fully declarative and leveraging the power of Nix for custom packages and configurations.

![NixOS](https://img.shields.io/badge/NixOS-unstable-5277C3?style=flat-square&logo=nixos&logoColor=white)

---

## 🔧 The Wrapper Pattern

All my packages use `symlinkJoin` + `wrapProgram` to inject configuration using only nix (no home-manager!):

```nix
# pkgs/ghostty/default.nix
pkgs.symlinkJoin {
  name = "ghostty-wrapped";
  paths = [ pkgs.ghostty ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/ghostty \
      --add-flags "--config-file=${./config}"
  '';
}
```

---

## 🩹 Mergiraf Patch System

Applying multiple community patches to dwl usually causes conflicts. `apply-patches.nix` solves this:

```nix
# lib/apply-patches.nix (simplified)
pkgs.stdenvNoCC.mkDerivation {
  patchPhase = ''
    git init
    git config merge.mergiraf.driver "mergiraf merge --git %O %A %B ..."

    for p in "''${PATCHES[@]}"; do
      git am --3way "$p" || {
        # Apply fixups for manual conflict resolution
        for f in "''${FIXUPS[@]}"; do
          git apply "$f" || true
        done
        git am --continue
      }
    done
  '';
}
```

**How it works:**
- Uses **mergiraf** for intelligent 3-way merging
- Falls back to fixup patches when needed
- Result: clean patch stacking that "just works"

```nix
# pkgs/dwl/default.nix
dwlSrc = applyPatches {
  src = pkgs.fetchgit { url = "https://codeberg.org/dwl/dwl.git"; /* ... */ };
  patches = [
    (pkgs.fetchurl { url = "...movestack.patch"; })
    (pkgs.fetchurl { url = "...bar.patch"; })
  ];
};
```

---

## 📝 Neovim with nixCats

A [nixCats](https://github.com/BirdeeHub/nixCats-nvim) config running Neovim nightly:

```nix
# pkgs/nvim/default.nix (highlights)
lspsAndRuntimeDeps = {
  general = [
    lua-language-server
    nil  # Nix LSP
    stylua
    ripgrep fd
    customPkgs.tidal-language-server  # Haskell Music LSP packaged by me :)
  ];
};

startupPlugins = {
  general = [
    blink-cmp oil-nvim
    flash-nvim harpoon2
    nvim-treesitter.withAllGrammars
    # ... 40+ more
  ];
};

settings = {
  neovim-unwrapped = neovim-nightly-overlay.packages.${system}.neovim;
};
```

---

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/gavbog/nixos ~/.config/nixos
cd ~/.config/nixos

# Build and switch
sudo nixos-rebuild switch --flake .#<hostname>

# Try individual packages
nix run .#nvim
nix run .#ghostty
nix build .#dwl
```

---

## 💻 Systems

| Hostname      | Description                |
|---------------|----------------------------|
| `mac`         | Apple Silicon (Asahi)      |

Each system has its own configuration defined under `systems/`:

```
systems/
└── mac/                 # Apple Silicon setup
```

---

## 📁 Structure

```
.
├── flake.nix
├── pkgs/
│   ├── dwl/           # Patched Wayland compositor
│   ├── nvim/          # nixCats Neovim config
│   ├── ghostty/       # Terminal wrapper
│   ├── zsh/           # Shell with Starship + Zinit
│   ├── librewolf/     # Browser
│   └── ...
├── lib/
│   └── apply-patches.nix  # Mergiraf patch utility
├── modules/           # NixOS modules (audio, bluetooth, etc.)
└── systems/           # Host-specific configurations
```

---

<div align="center">
<i>Built with ❄️ Nix</i>
</div>

