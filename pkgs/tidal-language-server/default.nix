{ pkgs }:
let
  tidalLspSrc = pkgs.fetchFromGitHub {
    owner = "bsssssss";
    repo = "tidal-language-server";
    rev = "0caeb6e6a133df16deb34b5702799d0918fe954f";
    sha256 = "sha256-CsEABbPuD99fsg3jm0mpueQ2MbZBwIh+KCPAmRxYkJU=";
  };

  tidalSrc = pkgs.fetchgit {
    url = "https://codeberg.org/uzu/tidal";
    rev = "fb05f0f22f096acf1f6b0e45209da942d5792b35";
    hash = "sha256-c8/9F6zI86CduMSzJcmmO3H6IqOneJF5Zov3BacYQs8=";
  };

  hpkgs = pkgs.haskell.packages.ghc96.override {
    overrides = self: super: {
      mkDerivation =
        args:
        super.mkDerivation (
          args
          // {
            doCheck = false;
          }
        );

      fuzzyfind = super.fuzzyfind.overrideAttrs (_: {
        meta.broken = false;
      });
    };
  };

  tidalLsp = hpkgs.callCabal2nix "tidal-language-server" tidalLspSrc { };
in
pkgs.symlinkJoin {
  name = "tidal-language-server";
  paths = [ tidalLsp ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/tidal-language-server \
      --set TIDAL_SRC_PATH ${tidalSrc}
  '';
}
