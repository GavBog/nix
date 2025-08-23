{
  packages =
    pkgs:
    let
      inherit (pkgs) callPackage;
    in
    {
      ghostty = callPackage ./ghostty { };
      librewolf = callPackage ./librewolf { };
      zsh = callPackage ./zsh { };
    };
}
