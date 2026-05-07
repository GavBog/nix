{ pkgs, tidal }:
let
  tidalLspSrc = pkgs.fetchFromGitHub {
    owner = "bsssssss";
    repo = "tidal-language-server";
    rev = "0caeb6e6a133df16deb34b5702799d0918fe954f";
    sha256 = "sha256-CsEABbPuD99fsg3jm0mpueQ2MbZBwIh+KCPAmRxYkJU=";
  };

  hlib = pkgs.haskell.lib;

  # Upgraded from ghc96 for the binary cache.
  # If it breaks pin it to a stable nixpkgs version or revert.
  hpkgs = pkgs.haskellPackages.override {
    overrides = self: super: {
      fuzzyfind = hlib.doJailbreak (
        super.fuzzyfind.overrideAttrs (_: {
          meta.broken = false;
        })
      );
    };
  };

  tidalLsp = hlib.doJailbreak (hpkgs.callCabal2nix "tidal-language-server" tidalLspSrc { });
in
pkgs.symlinkJoin {
  name = "tidal-language-server";
  paths = [ tidalLsp ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/tidal-language-server \
      --set TIDAL_SRC_PATH ${tidal}
  '';
}
