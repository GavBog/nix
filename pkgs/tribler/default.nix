{ pkgs }:
let
  inherit (pkgs) lib fetchFromGitHub buildNpmPackage;

  version = "8.4.1";
  python3 = pkgs.python312;
  nodejs = pkgs.nodejs_24;

  src = fetchFromGitHub {
    owner = "tribler";
    repo = "Tribler";
    rev = "db9bb75f5a08e36fa2be48ab3dbdcc0679aa25da";
    hash = "sha256-EhiIC+gxv7SVCrzfOSiOGWm1+y2sUlWmBz2Vva9IV6s=";
  };

  tribler-webui = buildNpmPackage {
    inherit nodejs version;
    pname = "tribler-webui";
    src = "${src}/src/tribler/ui";
    npmDepsHash = "sha256-JfpoBbm5CPLUXpCqDCqa13ihr9vZdL8ST4NEIWY0rjw=";

    npmPackFlags = [ "--ignore-scripts" ];
    NODE_OPTIONS = "--openssl-legacy-provider";

    dontNpmBuild = true;
    dontNpmInstall = true;

    installPhase = ''
      mkdir -pv $out
      cp -prvd ./* $out/
      cd $out
      npm install
      npm run build
    '';
  };

in

python3.pkgs.buildPythonApplication {
  inherit version src;
  name = "tribler";
  pyproject = true;

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    pyipv8
    ipv8-rust-tunnels
    libtorrent-rasterbar
    lz4
    pillow
    pony
    pystray
    cx-freeze
    requests
  ];

  nativeBuildInputs = [ pkgs.wrapGAppsHook3 ];

  buildInputs =
    (with python3.pkgs; [
      pygobject3
      sphinxHook
      sphinx
      sphinx-autoapi
      sphinx-rtd-theme
      astroid
      pytestCheckHook
    ])
    ++ [ pkgs.libappindicator-gtk3 ];

  postPatch = ''
    substituteInPlace build/setup.py --replace-fail '"tribler=tribler.run:main"' '"tribler=tribler.run:main_sync"'
    substituteInPlace src/run_tribler.py --replace-fail 'if __name__ == "__main__":' 'def main_sync():'
    substituteInPlace build/win/build.py --replace-fail "if {'setup.py', 'bdist_wheel'}.issubset(sys.argv):" "if True:"

    rm -r src/tribler/ui
    ln -s ${tribler-webui} src/tribler/ui
  '';

  buildPhase = ''
    runHook preBuild
    export GITHUB_TAG=v${version}
    python3 build/debian/update_metainfo.py
    python3 build/setup.py bdist_wheel
    runHook postBuild
  '';

  postInstall = ''
    ln -s ${tribler-webui} $out/${python3.sitePackages}/tribler/ui
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GI_TYPELIB_PATH : "${
        lib.makeSearchPath "lib/girepository-1.0" [ pkgs.libappindicator-gtk3 ]
      }"
    )
  '';

  disabledTests = [
    "test_request_for_version"
    "test_establish_connection"
    "test_tracker_test_error_resolve"
    "test_get_default_fallback"
    "test_get_default_fallback_half_tree"
    "test_get_set_explicit"
  ];

  passthru.updateScript = pkgs.nix-update-script { };

  meta = {
    description = "Decentralized P2P filesharing client based on the Bittorrent protocol";
    mainProgram = "tribler";
    homepage = "https://www.tribler.org/";
    changelog = "https://github.com/Tribler/tribler/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
