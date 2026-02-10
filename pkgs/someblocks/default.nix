{
  pkgs,
  configFile ? ./blocks.h,
}:
let
  src = pkgs.fetchgit {
    url = "https://git.sr.ht/~raphi/someblocks";
    rev = "540a90e521e7c17c2010e038b934b73d2cf46df3";
    hash = "sha256-L+O6vq+cSPvxDDNiwNqRJCSrtsbiQ7SUw//HXkaZF88=";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "someblocks";
  version = "1.0.1";
  inherit src;

  buildInputs = [ ];
  makeFlags = [ "PREFIX=$(out)" ];
  NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  dontConfigure = true;

  postPatch = ''
    cp ${configFile} blocks.h
  '';

  meta = {
    description = "Fork of dwmblocks, modified to connect to somebar instead of dwm.";
    license = pkgs.lib.licenses.isc;
  };
}
