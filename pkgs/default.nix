{
  inputs,
  ...
}:
{
  packages =
    pkgs:
    let
      inherit (pkgs) callPackage;
      pkgs-stable = import inputs.nixpkgs-stable {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
      customPkgs = {
        ghostty = callPackage ./ghostty { };
        librewolf = callPackage ./librewolf { };
        zsh = callPackage ./zsh { };
        someblocks = callPackage ./someblocks { };
        dwl = callPackage ./dwl { inherit customPkgs; };
        tidal-language-server = callPackage ./tidal-language-server { };
        impactor = callPackage ./impactor { };
        tribler-docker = callPackage ./tribler/docker.nix { pkgs = pkgs-stable; };
      };
      nvimExports = import ./nvim {
        inherit customPkgs;
        inherit (inputs)
          nixpkgs
          nixCats
          tidal-cycles
          neovim-nightly-overlay
          ;
      };
    in
    customPkgs // { nvim = nvimExports.packages.${pkgs.stdenv.hostPlatform.system}.nvim; };
}
