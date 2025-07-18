{
  description = "Gavin Bogie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nvim.url = "github:GavBog/nix?dir=pkgs/nvim";
  };

  outputs = { self, nixpkgs, nvim, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      # Re-export nvim for use independently
      apps = forAllSystems (system: {
        nvim = {
          type = "app";
          program = "${nvim.packages.${system}.default}/bin/nvim";
        };
      });
      # Mac Asahi Configuration
      nixosConfigurations.mac = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          {
            environment.systemPackages =
              [ nvim.packages.aarch64-linux.default ];
          }
          ./configurations/mac/configuration.nix
        ];
      };
    };
}
