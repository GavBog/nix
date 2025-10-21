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
      dwl = callPackage ./dwl { };
      tidal-language-server = callPackage ./tidal-language-server { };
    };
}
