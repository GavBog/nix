{
  pkgs,
  customPkgs,
  lib,
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
      rev = "a8915224e8159e6e0b6ff0fe7b2c6436fb3a1b6d";
      hash = "sha256-fOQ9B+5YFZeYJswsCAZd7FruiFRxUBC9ZyaX4UysNvo=";
    };
    excludeFiles = [ "config.def.h" ];
    patches = [
      # (builtins.path {
      #   name = "ipc-patch";
      #   path = ./patches/ipc.patch;
      # })

      # Add this later
      # https://codeberg.org/dwl/dwl-patches/src/branch/main/patches/chainkeys/chainkeys.patch

      (pkgs.fetchurl {
        url = "https://codeberg.org/dwl/dwl-patches/raw/commit/f24e98a304a818b80b00dbd49faafac99b2672f0/patches/movestack/movestack.patch";
        hash = "sha256-9Bs6YIMsIN1SpysB3dem+L5Gxg+VwwkXPSQ1W5n4ZOA=";
      })

      # WARN: DWL IPC
      # https://codeberg.org/dwl/dwl-patches/issues/578
      (pkgs.fetchurl {
        url = "https://codeberg.org/attachments/68631114-befa-4f90-9605-1463f14cd649";
        hash = "sha256-aPYKloeXxRWegKY/ICqkk80foFY7VErAV9mw8UAcrIA=";
      })
    ];
    fixups = [
      # (builtins.path {
      #   name = "patch-fixup";
      #   path = ./fixups/patch-fixup.patch;
      # })
    ];
  };

  dwl = pkgs.dwl.overrideAttrs (old: {
    version = "0.8-dev";
    src = dwlSrc;
    buildInputs = (old.buildInputs or [ ]) ++ [
      pkgs.wlroots_0_19
    ];

    postPatch = (old.postPatch or "") + ''
      cp ${configFile} config.h
    '';
  });

  dwlPostStart = lib.trim ''
    if [ -r ${wallpaper} ]; then
      ${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill &
    else
      ${pkgs.swaybg}/bin/swaybg -i ${../../assets/wallpaper.svg} -m fill &
    fi
    ${pkgs.dwlb}/bin/dwlb -ipc &
    (
      while ! pgrep -x dwlb > /dev/null; do sleep 0.1; done
      ${customPkgs.someblocks}/bin/someblocks -p | ${pkgs.dwlb}/bin/dwlb -status-stdin all
    ) &
  '';

  dwlStart = pkgs.writeShellScriptBin "dwl-start" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=dwl
    export XDG_SESSION_DESKTOP=dwl

    ${dwl}/bin/dwl -s "${dwlPostStart}"
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
