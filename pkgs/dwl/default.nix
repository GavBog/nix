{
  pkgs,
  configFile ? ./config.h,
  wallpaper ? ../../assets/wallpaper.svg,
}:
let
  applyPatches = import ../../lib/apply-patches.nix {
    inherit pkgs;
  };

  dwlSrc = applyPatches {
    name = "dwl-patched-src";
    src = pkgs.fetchgit {
      url = "https://codeberg.org/dwl/dwl.git";
      rev = "15bfffd87a6f9da0bc551db95c7c2a9a069b3708";
      hash = "sha256-AvhGE0PGlwtX+wn59kw+9cH3vHa3S+REEOD9IIzHNxU=";
    };
    patches = [
      # (builtins.path {
      #   name = "ipc-patch";
      #   path = ./patches/ipc.patch;
      # })
      (pkgs.fetchurl {
        url = "https://codeberg.org/dwl/dwl-patches/raw/commit/2e03d8ec91f4acb20d4890a3b26fac01a9eb6fb4/patches/movestack/movestack.patch";
        hash = "sha256-9Bs6YIMsIN1SpysB3dem+L5Gxg+VwwkXPSQ1W5n4ZOA=";
      })
      (pkgs.fetchurl {
        url = "https://codeberg.org/dwl/dwl-patches/raw/commit/adda83d5c4dbdc8b8947398d45440885120c0cde/patches/bar/bar.patch";
        hash = "sha256-+XU53ZdOYoPnCSNm/1CbDDmAwkFl+tzRgaBLr54by2Q=";
      })
    ];
    fixups = [ ];
  };

  dwl = pkgs.dwl.overrideAttrs (old: {
    version = "0.8-dev";
    src = dwlSrc;

    buildInputs = (old.buildInputs or [ ]) ++ [
      pkgs.wlroots_0_19
      pkgs.tllist
      pkgs.fcft
      pkgs.pixman
      pkgs.libdrm
    ];

    postPatch = (old.postPatch or "") + ''
      cp ${configFile} config.h
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
