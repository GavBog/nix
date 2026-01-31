{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}:

let
  archMap = {
    "aarch64-linux" = {
      url = "https://github.com/khcrysalis/Impactor/releases/download/v2.0.3/Impactor-linux-aarch64.appimage";
      sha256 = "sha256-w1V4M53D3MNyY4JVUfyNq3v8M21hrfLWh2Z2p+4P9SM=";
    };

    "x86_64-linux" = {
      url = "https://github.com/khcrysalis/Impactor/releases/download/v2.0.3/Impactor-linux-x86_64.appimage";
      sha256 = "sha256-zT0XTTGJGffSDqdHZlybvtg9uybKF1iUQaVRyZvBwO4=";
    };
  };

  arch = archMap.${stdenv.system} or (throw "Impactor is not available for ${stdenv.system}");
in

appimageTools.wrapType2 {
  pname = "impactor";
  version = "2.0.3";
  src = fetchurl arch;

  meta = with lib; {
    description = "Impactor AppImage";
    homepage = "https://github.com/khcrysalis/Impactor";
    license = licenses.mit;
    platforms = builtins.attrNames archMap;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
