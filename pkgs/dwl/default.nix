{
  pkgs,
  configFile ? ./config.h,
  wallpaper ? ../../assets/temp-wallpaper.jpg,
}:
let
  patches = [
    # (pkgs.fetchurl {
    #   url = "https://codeberg.org/dwl/dwl-patches/raw/commit/770aad7716ecd08774d99e9905f2ebb0c1f719fa/patches/bar/bar.patch";
    #   hash = "sha256-+XU53ZdOYoPnCSNm/1CbDDmAwkFl+tzRgaBLr54by2Q=";
    # })
    (builtins.path {
      name = "foreign-toplevel-management-patch";
      path = ./patches/ftlm.patch;
    })
    (builtins.path {
      name = "ipc-patch";
      path = ./patches/ipc.patch;
    })
  ];

  dwl = pkgs.dwl.overrideAttrs (old: {
    version = "0.8-dev";
    src = pkgs.fetchgit {
      url = "https://codeberg.org/dwl/dwl.git";
      rev = "15bfffd87a6f9da0bc551db95c7c2a9a069b3708";
      hash = "sha256-AvhGE0PGlwtX+wn59kw+9cH3vHa3S+REEOD9IIzHNxU=";
    };

    buildInputs = (old.buildInputs or [ ]) ++ [
      pkgs.wlroots_0_19
      pkgs.tllist
      pkgs.fcft
      pkgs.pixman
      pkgs.libdrm
    ];

    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      pkgs.git
      pkgs.mergiraf
    ];

    patchPhase = ''
      runHook prePatch

      git init
      git config merge.conflictStyle diff3
      git config user.email "builder@nixos.invalid"
      git config user.name "Nix Builder"
      git add .
      git commit -m "base tree"

      for p in ${toString patches}; do
        git am --3way "$p" || true
      done

      runHook postPatch
    '';

    postPatch = (old.postPatch or "") + ''
      cp ${configFile} config.h

      find . -type f ! -path '*/.git/*' -print0 | while IFS= read -r -d "" f; do
        if grep -q '^<<<<<<< HEAD' "$f"; then
          case "$(basename "$f")" in
            Makefile|GNUmakefile) mergiraf solve "$f" --language "GNU Make" || true ;;
            *) mergiraf solve "$f" || true ;;
          esac

          # Fallback: strip confict markers, keep both sides
          awk '
            BEGIN { inconflict = 0 }
            /^<<<<<<< / { inconflict = 1; next }
            /^\|\|\|\|\|\|\|/ { inconflict = 3; next }
            /^=======/ { inconflict = 2; next }
            /^>>>>>>> / { inconflict = 0; next }
            inconflict == 0 { print; next }
            inconflict == 1 { print; next }
            inconflict == 3 { next }
            inconflict == 2 { print; next }
          ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
        fi
      done
    '';
  });

  dwlStart = pkgs.writeShellScriptBin "dwl-start" ''
    #!${pkgs.runtimeShell}
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=dwl
    export XDG_SESSION_DESKTOP=dwl

    ${dwl}/bin/dwl & dwlpid=$!

    sock="$XDG_RUNTIME_DIR/wayland-0"
    for i in $(seq 1 50); do [ -S "$sock" ] && break; sleep 0.1; done

    ${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill &
    wait "$dwlpid"
  '';

  dwlDesktop = pkgs.writeTextFile {
    name = "dwl.desktop";
    destination = "/share/wayland-sessions/dwl.desktop";
    text = ''
      [Desktop Entry]
      Name=dwl
      Exec=${dwlStart}/bin/dwl-start
      Type=Application
    '';
  };
in
pkgs.symlinkJoin {
  name = "dwl";
  paths = [
    dwlDesktop
    dwlStart
    dwl
  ];
  passthru.providedSessions = [ "dwl" ];
}
