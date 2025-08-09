{
  description = "Gavin Bogie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nvim.url = "github:GavBog/nix?dir=pkgs/nvim";
    librewolf.url = "github:GavBog/nix?dir=pkgs/librewolf";
    # nixos-apple-silicon = {
    #   url = "github:nix-community/nixos-apple-silicon";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO: remove this when https://github.com/nix-community/nixos-apple-silicon/issues/301 is closed
    nixos-apple-silicon = {
      type = "github";
      owner = "flokli";
      repo = "nixos-apple-silicon";
      ref = "mainline-mesa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nvim,
    librewolf,
    ...
  } @ inputs: let
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
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in (wrappedPackages.packages pkgs)
    );
  in {
    # Re-export nvim for use independently
    apps = forAllSystems (system: {
      nvim = {
        type = "app";
        program = "${nvim.packages.${system}.default}/bin/nvim";
      };
      librewolf = {
        type = "app";
        program = "${librewolf.packages.${system}.default}/bin/librewolf";
      };
    });

    formatter = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.alejandra
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
          environment.systemPackages = [nvim.packages.aarch64-linux.default];
        }
        {
          nix.settings = {
            extra-substituters = ["https://cache.garnix.io" "https://nixos-asahi.cachix.org"];
            extra-trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" "nixos-asahi.cachix.org-1:CPH9jazpT/isOQvFhtAZ0Z18XNhAp29+LLVHr0b2qVk="];
          };
        }
        ./modules/dotfiles.nix
        ./configurations/mac/configuration.nix
      ];
    };
  };
}
