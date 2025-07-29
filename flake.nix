{
  description = "Gavin Bogie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nvim.url = "github:GavBog/nix?dir=pkgs/nvim";
    # Switch back when https://github.com/lilyinstarlight/nixos-cosmic/pull/863 is merged
    # nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic = {
      type = "github";
      owner = "jerbaroo";
      repo = "nixos-cosmic";
      ref = "patch-1";
    };
  };

  outputs = { self, nixpkgs, nvim, nixos-cosmic, ... }@inputs:
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
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./configurations/mac/configuration.nix
        ];
      };
    };
}
