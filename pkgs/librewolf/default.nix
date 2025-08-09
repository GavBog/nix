{pkgs}: let
  profileName = "gavbog.default";

  librewolfWithExt = pkgs.wrapFirefox pkgs.librewolf-unwrapped {
    inherit (pkgs.librewolf-unwrapped) extraPrefsFiles extraPoliciesFiles;
    wmClass = "LibreWolf";
    libName = "librewolf";
    nativeMessagingHosts = with pkgs; [tridactyl-native];

    # Documentation about policies options can be found at `about:policies#documentation`.
    # You can also have a look here: https://github.com/mozilla/policy-templates/.
    extraPolicies = {
      # Bookmarks = bookmarks;
      ExtensionSettings = import ./nix/extensions.nix;
    };
  };

  profileSkel = builtins.path {
    name = "librewolf-profile-skel";
    path = ./profile;
  };

  profilesIni = builtins.path {
    name = "librewolf-profiles-ini";
    path = ./profiles.ini;
  };

  # Shell-evaluated at runtime; expands to ~/.librewolf if XDG isn't set
  configDir = "${"\${XDG_CONFIG_HOME:-\$HOME/.librewolf}"}";
  fullProfilePath = "${configDir}/${profileName}";
in
  pkgs.symlinkJoin {
    name = "librewolf-wrapped";
    paths = [librewolfWithExt];
    nativeBuildInputs = [pkgs.makeWrapper];

    postBuild = ''
      mkdir -p "$out/share/librewolf-profile"
      cp -r ${profileSkel}/. "$out/share/librewolf-profile"

      mkdir -p "$out/share/librewolf-meta"
      cp ${profilesIni} "$out/share/librewolf-meta/profiles.ini"

      wrapProgram "$out/bin/librewolf" \
        --set OUT "$out" \
        --prefix PATH : ${pkgs.rsync}/bin \
        --run 'set -euo pipefail
          config_dir=${configDir}
          profile_dir="$config_dir/${profileName}"

          mkdir -p "$profile_dir"
          rsync -a --checksum --no-perms --no-owner --no-group \
            "$OUT/share/librewolf-profile/" "$profile_dir/"

          mkdir -p "$config_dir"
          rsync -a --checksum --no-perms --no-owner --no-group \
            "$OUT/share/librewolf-meta/profiles.ini" "$config_dir/profiles.ini"
        ' \
        --add-flags "--profile=${fullProfilePath}"
    '';
  }
