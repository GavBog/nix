{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "impactor";
  version = "2.0.3";

  src = fetchurl {
    url = "https://github.com/khcrysalis/Impactor/releases/download/v${version}/Impactor-linux-aarch64.appimage";
    sha256 = "sha256-w1V4M53D3MNyY4JVUfyNq3v8M21hrfLWh2Z2p+4P9SM=";
  };

  meta = with lib; {
    description = "Impactor AppImage";
    homepage = "https://github.com/khcrysalis/Impactor";
    license = licenses.mit;
    platforms = [ "aarch64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
