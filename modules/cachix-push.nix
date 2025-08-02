{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.services.cachixPush;
in
  with lib; {
    options.services.cachixPush = {
      enable = mkEnableOption "Enable automatic Cachix push of built derivations";

      cacheName = mkOption {
        type = types.str;
        description = "Name of the Cachix cache to push to";
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [pkgs.cachix];

      nix.settings.post-build-hook = pkgs.writeShellScript "upload-to-cachix" ''
        if [ -z "$CACHIX_AUTH_TOKEN" ]; then
          echo "[post-build-hook] Skipping push: CACHIX_AUTH_TOKEN not set."
          exit 0
        fi

        export CACHIX_AUTH_TOKEN
        exec ${pkgs.cachix}/bin/cachix push ${cfg.cacheName} "$@"
      '';
    };
  }
