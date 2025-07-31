{
  packages = pkgs: let
    inherit (pkgs) callPackage;
  in {
    ghostty = callPackage ./ghostty {};
  };
}

