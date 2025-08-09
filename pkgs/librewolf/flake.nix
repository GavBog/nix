{
  description = "LibreWolf wrapper with seeded profile and profiles.ini";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "i686-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        librewolf-wrapped = pkgs.callPackage ./default.nix {};
        default = self.packages.${system}.librewolf-wrapped;
      }
    );

    apps = forAllSystems (system: {
      librewolf = {
        type = "app";
        program = "${self.packages.${system}.librewolf-wrapped}/bin/librewolf";
      };
      default = self.apps.${system}.librewolf;
    });
  };
}
