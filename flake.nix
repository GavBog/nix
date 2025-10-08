{
  description = "Gavin Bogie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tidal-cycles = {
      url = "github:mitchmindtree/tidalcycles.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      neovim-nightly-overlay,
      nix-index-database,
      tidal-cycles,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      wrappedPackages = import ./pkgs/default.nix;
      customPkgs = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        (wrappedPackages.packages pkgs)
      );
      nvimExports = import ./pkgs/nvim {
        inherit nixpkgs;
        inherit nixCats;
        inherit neovim-nightly-overlay;
      };
    in
    {
      # Re-export nvim for use independently
      apps = forAllSystems (system: {
        nvim = {
          type = "app";
          program = "${nvimExports.packages.${system}.nvim}/bin/nvim";
        };
        librewolf = {
          type = "app";
          program = "${customPkgs.${system}.librewolf}/bin/librewolf";
        };
      });

      formatter = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.nixfmt-tree
      );

      # Mac Asahi Configuration
      nixosConfigurations.mac = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          customPkgs = customPkgs.aarch64-linux;
        };
        modules = [
          {
            nixpkgs.overlays = import ./overlays;
            environment.systemPackages = [
              nvimExports.packages.aarch64-linux.nvim
              tidal-cycles.packages.aarch64-linux.ghcWithTidal
              tidal-cycles.packages.aarch64-linux.supercollider
              tidal-cycles.packages.aarch64-linux.sclang-with-superdirt
              # tidal-cycles.packages.aarch64-linux.superdirt-start-sc
              tidal-cycles.packages.aarch64-linux.superdirt-start
              tidal-cycles.packages.aarch64-linux.superdirt-install
              tidal-cycles.packages.aarch64-linux.tidal
              # tidal-cycles.packages.aarch64-linux.vim-tidal
            ];
          }
          {
            nix.settings = {
              extra-substituters = [
                "https://cache.garnix.io"
                "https://nix-community.cachix.org"
                "https://nixos-apple-silicon.cachix.org"
              ];
              extra-trusted-public-keys = [
                "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
              ];
            };
          }
          nix-index-database.nixosModules.nix-index
          ./configurations/mac/configuration.nix
        ]
        ++ (import ./modules);
      };
    };
}
