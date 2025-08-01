{pkgs, ...}: let
  toml = pkgs.formats.toml {};

  starship-settings = import ./starship.nix;
  aliases = import ./aliases.nix;
  zconfig = import ./zinit.nix {inherit pkgs aliasesStr;};

  aliasesStr =
    pkgs.lib.concatStringsSep "\n"
    (pkgs.lib.mapAttrsToList (k: v: "alias ${k}=\"${v}\"") aliases);
in
  (pkgs.symlinkJoin {
    name = "zsh-wrapped";
    paths = [pkgs.zsh pkgs.starship];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/zsh --set STARSHIP_CONFIG "${toml.generate "starship.toml" starship-settings}" \
        --set ZDOTDIR "${zconfig}/bin"
    '';
  })
  .overrideAttrs (_: {
    passthru = {
      shellPath = "/bin/zsh";
    };
  })
