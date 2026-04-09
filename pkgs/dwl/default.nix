{
  pkgs,
  customPkgs,
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

      (pkgs.fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/commit/f24e98a304a818b80b00dbd49faafac99b2672f0/patches/movestack/movestack.patch";
        hash = "sha256-/Ac7oQyZNVPqGiNDn0y94arN0cz98Ie1nKkQIX27bZo=";
      })

      # WARN: DWL IPC
      # https://codeberg.org/dwl/dwl-patches/pulls/626
      (pkgs.fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/commit/d00a92263c2df094a21828658f37f6584ae1df1b/patches/ipc/ipc.patch";
        hash = "sha256-vzMj30SsALLF0Ft7NkTqF6Ez55bjD3PYm9uk5gy+Z/4=";
      })

      (pkgs.fetchpatch {
        url = "https://codeberg.org/dwl/dwl-patches/raw/commit/2d4463dd832885f3e657fbe93c4b26296ef6f93a/patches/singletagset/singletagset-v0.7.patch";
        hash = "sha256-ppyLAdYIHOFCZ53/dBpxR3T3jSx5TfSApo0GI18M0tE=";
      })
    ];
    fixups = [
      (builtins.path {
        name = "singletagset-patch";
        path = ./fixups/singletagset.patch;
      })
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

  dwlPostStart = pkgs.writeShellScript "dwl-post-start" ''
    ${pkgs.uwsm}/bin/uwsm finalize WAYLAND_DISPLAY
    ${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill &
    ${pkgs.dwlb}/bin/dwlb -ipc &
    (
      while ! pgrep -x dwlb > /dev/null; do sleep 0.1; done
      ${customPkgs.someblocks}/bin/someblocks -p | ${pkgs.dwlb}/bin/dwlb -status-stdin all
    ) &
  '';

  dwlStart = pkgs.writeShellScriptBin "dwl-start" ''
    exec ${pkgs.uwsm}/bin/uwsm start -- \
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
