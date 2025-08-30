final: prev:

let
  config = builtins.path {
    name = "kwin-config";
    path = ./config;
  };
in
{
  kdePackages = prev.kdePackages // {
    kwin = prev.symlinkJoin {
      name = "kwin-wayland-wrapped";
      paths = [ prev.kdePackages.kwin ];
      nativeBuildInputs = [ prev.makeWrapper ];

      postBuild = ''
        if [ -x "$out/bin/kwin_wayland" ]; then
          wrapProgram "$out/bin/kwin_wayland" \
            --set XDG_CONFIG_HOME "${config}"
        fi
      '';
    };
  };
}
