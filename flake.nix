{
  description = "Gavin Bogie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
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
            environment.systemPackages = [ nvimExports.packages.aarch64-linux.nvim ];
          }
          {
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
          ./configurations/mac/configuration.nix
        ]
        ++ (import ./modules);
      };
    };
}
