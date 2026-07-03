{
  ...
}:
{
  packages =
    pkgs:
    let
      inherit (pkgs) callPackage;

      customPkgs = {
        tidal-nvim = callPackage ./tidal-nvim { };
      };
    in
    customPkgs;
}
