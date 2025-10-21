{ pkgs }:
let
  tidalLspSrc = pkgs.fetchFromGitHub {
    owner = "bsssssss";
    repo = "tidal-language-server";
    rev = "0caeb6e6a133df16deb34b5702799d0918fe954f";
    sha256 = "sha256-CsEABbPuD99fsg3jm0mpueQ2MbZBwIh+KCPAmRxYkJU=";
  };

  tidalSrc = builtins.fetchTree {
    type = "git";
    url = "https://codeberg.org/uzu/tidal";
    rev = "660ac746ec5c89da7ead100c0c46bf67e4037f41";
    narHash = "sha256-kuhf4uN+jWyq97MnnDQTTKca2IRzJu16xU4R0VwMrhc=";
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
