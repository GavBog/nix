{
  description = "Gavin Bogie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    determinate-nix.url = "github:DeterminateSystems/nix-src";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
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
      determinate-nix,
      nixCats,
      nix-index-database,
      sops-nix,
      neovim-nightly-overlay,
      nvim-treesitter-main,
      tidal-cycles,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      customPkgs = import ./pkgs/default.nix { inherit inputs; };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        customPkgs.packages pkgs
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        pkgs.nixfmt-tree
      );

      # Mac Asahi Configuration
      nixosConfigurations.mac = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          customPkgs = self.packages.aarch64-linux;
        };
        modules = (import ./modules) ++ [
          {
            environment.systemPackages = [
              tidal-cycles.packages.aarch64-linux.ghcWithTidal
              tidal-cycles.packages.aarch64-linux.superdirt-start
              tidal-cycles.packages.aarch64-linux.tidal
            ];
          }
          {
            nix.package = determinate-nix.packages.aarch64-linux.default;
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
          sops-nix.nixosModules.sops
          ./systems/mac/configuration.nix
        ];
      };
      nixosConfigurations.x86 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          customPkgs = self.packages.x86_64-linux;
        };
        modules = (import ./modules) ++ [
          {
            environment.systemPackages = [
              tidal-cycles.packages.x86_64-linux.ghcWithTidal
              tidal-cycles.packages.x86_64-linux.superdirt-start
              tidal-cycles.packages.x86_64-linux.tidal
            ];
          }
          {
            nix.package = determinate-nix.packages.x86_64-linux.default;
            nix.settings = {
              extra-substituters = [
                "https://cache.garnix.io"
                "https://nix-community.cachix.org"
              ];
              extra-trusted-public-keys = [
                "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              ];
            };
          }
          nix-index-database.nixosModules.nix-index
          sops-nix.nixosModules.sops
          ./systems/x86/configuration.nix
        ];
      };
    };
}
