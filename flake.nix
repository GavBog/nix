{
  description = "Gavin Bogie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
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
    tidal-cycles = {
      url = "github:mitchmindtree/tidalcycles.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aea-tools = {
      url = "github:GavBog/aea-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      determinate-nix,
      nixCats,
      nix-index-database,
      sops-nix,
      neovim-nightly-overlay,
      tidal-cycles,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "riscv64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      customPkgs = import ./pkgs/default.nix { inherit inputs; };

      mkSystem =
        {
          configName,
          system,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            customPkgs = self.packages.${system};
            stablePkgs = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            {
              nix.package = determinate-nix.packages.${system}.default;
            }
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            ./systems/${configName}/configuration.nix
          ]
          ++ extraModules;
        };

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
          pkgs = import nixpkgs-stable {
            inherit system;
          };
        in
        pkgs.nixfmt-tree
      );

      nixosConfigurations = {
        mac = mkSystem {
          configName = "mac";
          system = "aarch64-linux";
          extraModules = (import ./modules/mac) ++ [ ];
        };

        x86 = mkSystem {
          configName = "x86";
          system = "x86_64-linux";
          extraModules = (import ./modules/x86) ++ [ ];
        };
      };
    };
}
