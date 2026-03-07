{ pkgs }:
let
  librewolf = pkgs.wrapFirefox pkgs.librewolf-unwrapped {
    inherit (pkgs.librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
    wmClass = "LibreWolf";
    libName = "librewolf";
    nativeMessagingHosts = with pkgs; [ tridactyl-native ];

    # Documentation about policies options can be found at `about:policies#documentation`.
    # You can also have a look here: https://github.com/mozilla/policy-templates/.
    extraPolicies = {
      Bookmarks = import ./config/bookmarks.nix;
      ExtensionSettings = import ./config/extensions.nix;
      Preferences = import ./config/preferences.nix;
    };
  };

  userChrome = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/rockofox/firefox-minima/dc40a861b24b378982c265a7769e3228ffccd45a/userChrome.css";
    hash = "sha256-sqHpdf2x5qdoY526KSz8xBRJsOK+z3frjTSdqHFS200=";
  };
in
pkgs.symlinkJoin {
  name = "librewolf";
  paths = [ librewolf ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/librewolf" \
      --set MOZ_ALLOW_DOWNGRADE 1 \
      --set MOZ_SKIP_CHECK_DEFAULT_BROWSER 1 \
      --run '
        PROF_DIR="$HOME/.librewolf/nix-portable"
        mkdir -p "$PROF_DIR/chrome"

        ln -sf "${userChrome}" "$PROF_DIR/chrome/userChrome.css"
      ' \
      --add-flags "--profile \$HOME/.librewolf/nix-portable"
  '';
}
