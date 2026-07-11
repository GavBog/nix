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

      nvimExports = import ./nvim {
        inherit customPkgs;
        inherit (inputs)
          nixpkgs
          nixCats
          tidal-cycles
          neovim-nightly-overlay
          ;
      };

      customPkgs = {
        ghostty = callPackage ./ghostty { };
        librewolf = callPackage ./librewolf { };
        zsh = callPackage ./zsh { };
        someblocks = callPackage ./someblocks { };
        dwl = callPackage ./dwl { inherit customPkgs; };
        tidal-language-server = callPackage ./tidal-language-server { tidal = inputs.tidal; };
        risc0 = callPackage ./risc0 { pkgs = pkgs-stable; };
        cartesi-machine = callPackage ./cartesi {
          pkgs = pkgs-stable;
          inherit customPkgs;
        };
        tribler = callPackage ./tribler { pkgs = pkgs-stable; };
        tribler-docker = callPackage ./tribler/docker.nix {
          pkgs = pkgs-stable;
          inherit customPkgs;
        };

        nvim = nvimExports.packages.${pkgs.stdenv.hostPlatform.system}.nvim;
        nvimPlugins = (import ./nvim/pluginPkgs { }).packages pkgs;
      };
    in
    customPkgs;
}
