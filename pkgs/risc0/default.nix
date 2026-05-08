{ pkgs }:
let
  risc0-cpp-toolchain = pkgs.fetchzip {
    url = "https://github.com/risc0/toolchain/releases/download/2024.01.05/riscv32im-linux-x86_64.tar.xz";
    hash = "sha256-7PfT55K/u2bIW/MXGep93dHolbzyCQjF6eCE2t6Z5as=";
    stripRoot = false;
  };

  risc0-rust-toolchain = pkgs.fetchzip {
    url = "https://github.com/risc0/rust/releases/download/r0.1.94.1/rust-toolchain-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-gQSM2fCK5Z1blp4p7CCXhVGP8nRLL9/IQjO72ZO+Fk8=";
    stripRoot = false;
  };

  r0vm-bin = pkgs.fetchzip {
    url = "https://github.com/risc0/risc0/releases/download/v3.0.5/cargo-risczero-x86_64-unknown-linux-gnu.tgz";
    hash = "sha256-lhu73LAY0GfBCjNBk2UqMfKxL/NYL2QffLab2z+0qO8=";
    stripRoot = false;
  };
in
pkgs.stdenv.mkDerivation {
  pname = "risc0";
  version = "patched";

  phases = [
    "installPhase"
    "fixupPhase"
  ];

  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = [
    pkgs.stdenv.cc.cc.lib
    pkgs.libgcc
    pkgs.zlib
    pkgs.gmp
    pkgs.mpfr
    pkgs.libmpc
  ];

  installPhase = ''
    mkdir -p $out/cpp $out/rust $out/r0vm-bin $out/bin

    cp -rL ${risc0-cpp-toolchain}/* $out/cpp/
    cp -rL ${risc0-rust-toolchain}/* $out/rust/
    cp -rL ${r0vm-bin}/* $out/r0vm-bin/

    ln -s $out/rust/bin/cargo $out/bin/cargo
    ln -s $out/rust/bin/rustc $out/bin/rustc
    ln -s $out/r0vm-bin/r0vm $out/bin/r0vm

    chmod -R +w $out
  '';
}
