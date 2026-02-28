{
  inputs,
  ...
}:
{
  packages =
    pkgs:
    let
      inherit (pkgs) callPackage;
      customPkgs = {
        ghostty = callPackage ./ghostty { };
        librewolf = callPackage ./librewolf { };
        zsh = callPackage ./zsh { };
        someblocks = callPackage ./someblocks { };
        dwl = callPackage ./dwl { inherit customPkgs; };
        tidal-language-server = callPackage ./tidal-language-server { };
        stremio = callPackage ./stremio { };
        impactor = callPackage ./impactor { };
        tribler-docker = callPackage ./tribler/docker.nix { };
      };
      nvimExports = import ./nvim {
        inherit customPkgs;
        inherit (inputs)
          nixpkgs
          nixCats
          neovim-nightly-overlay
          nvim-treesitter-main
          ;
      };
    in
    customPkgs // { nvim = nvimExports.packages.${pkgs.stdenv.hostPlatform.system}.nvim; };
}
