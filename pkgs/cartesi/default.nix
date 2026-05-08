{ pkgs, customPkgs }:
let
  cartesiVersion = "v0.20.0";
  stdenv = pkgs.gcc14Stdenv;

  risc0 = customPkgs.risc0;
  risc0-cpp-toolchain-dir = "${risc0}/cpp/riscv32im-linux-x86_64/bin";

  src = pkgs.fetchFromGitHub {
    owner = "cartesi";
    repo = "machine-emulator";
    rev = cartesiVersion;
    sha256 = "sha256-GRLXaV6Ry4kMri1k5+d6l1/L22wKZg9FBM5Va9WDzyQ=";
  };

  cartesi-risc0-cli = pkgs.rustPlatform.buildRustPackage {
    pname = "cartesi-risc0-cli";
    version = cartesiVersion;
    inherit src;
    sourceRoot = "${src.name}/risc0/rust";

    cargoHash = "sha256-+AA1qIiD4KHaqNLfj9w44DFjYtfdS1CpZogeXjpB6t0=";
    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.lua5_4
      risc0
    ];

    buildInputs = [
      pkgs.openssl
      pkgs.zlib
    ];

    preBuild = ''
      export HOME=$(mktemp -d) RISC0_CACHE_DIR="$HOME/.risc0"

      chmod -R +w ../../
      find ../../ -type f -name "*.lua" -exec sed -i 's/env lua5\.4/env lua/g' {} +
      patchShebangs ../../tools

      make -C ../cpp RISC0_CPP_TOOLCHAIN_DIR="${risc0}/cpp/riscv32im-linux-x86_64/bin"
    '';

    preConfigure = ''
      chmod -R +w $NIX_BUILD_TOP/*-vendor/risc0-build-*

      sed -i \
        -e 's|fn rust_toolchain() -> PathBuf {|#[allow(unreachable_code)] fn rust_toolchain() -> std::path::PathBuf { return std::path::PathBuf::from("${risc0}/rust");|' \
        -e 's|fn cpp_toolchain() -> Option<PathBuf> {|#[allow(unreachable_code)] fn cpp_toolchain() -> Option<std::path::PathBuf> { return Some(std::path::PathBuf::from("${risc0}/cpp"));|' \
        -e 's|fn get_rust_toolchain_version() -> semver::Version {|#[allow(unreachable_code)] fn get_rust_toolchain_version() -> semver::Version { return semver::Version::new(1, 82, 0);|' \
        $NIX_BUILD_TOP/*-vendor/risc0-build-*/src/lib.rs
    '';

    postPatch = ''
      find . -name "Cargo.lock" -mindepth 2 -delete
    '';

    doCheck = false;

    RISC0_REPRODUCIBLE_BUILD = 0;
    buildAndTestSubdir = "cartesi-risc0";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    gnumake
    lua5_4
    risc0
  ];

  buildInputs = with pkgs; [
    boost
    libslirp
    lua5_4
  ];

  linux-bin = pkgs.fetchurl {
    url = "https://github.com/cartesi/machine-linux-image/releases/download/v0.20.0/linux-6.5.13-ctsi-1-v0.20.0.bin";
    hash = "sha256-Zd0QD/YgQ0asL1D3cnITWLXBRRRQzrOaFUVC7ie0yUc=";
  };

  rootfs-ext2 = pkgs.fetchurl {
    url = "https://github.com/cartesi/machine-rootfs-image/releases/download/v0.20.0-test1/rootfs-alpine.ext2";
    hash = "sha256-P8ZTImmkjBs9PQ1CvOY8ogGdWoUgh3bWiMz1keFnUKE=";
  };
in
stdenv.mkDerivation {
  pname = "cartesi-machine";
  version = cartesiVersion;

  inherit nativeBuildInputs buildInputs src;

  patches = [
    (pkgs.fetchpatch {
      url = "https://github.com/cartesi/machine-emulator/releases/download/${cartesiVersion}/add-generated-files.diff";
      hash = "sha256-SdDbaj6FWOXWi6yxu9RLRIbcoTlkivVYP3LGQeAprjI=";
    })
  ];

  postPatch = ''
    find . -type f -name "*.lua" -exec sed -i 's/env lua5\.4/env lua/g' {} +
    find tools/template -type f -name "*.template" -exec sed -i "s|lua5\.4|${pkgs.lua5_4}/bin/lua|g" {} +
    patchShebangs .

    substituteInPlace risc0/rust/Makefile --replace "cargo build \$(CARGO_FEATURES)" "true"
    substituteInPlace risc0/rust/Makefile \
      --replace "cargo run --bin cartesi-risc0-cli --" "${cartesi-risc0-cli}/bin/cartesi-risc0-cli" \
      --replace "cargo run --quiet --bin cartesi-risc0-cli --" "${cartesi-risc0-cli}/bin/cartesi-risc0-cli"
  '';

  buildPhase = ''
    make
    make risc0 RISC0_CPP_TOOLCHAIN_DIR="${risc0-cpp-toolchain-dir}"
  '';

  installPhase = ''
    make install PREFIX=$out

    mkdir -p $out/bin
    ln -s ${cartesi-risc0-cli}/bin/cartesi-risc0-cli $out/bin/cartesi-risc0-cli

    mkdir -p $out/share/cartesi-machine/images
    ln -s ${linux-bin} $out/share/cartesi-machine/images/linux.bin
    ln -s ${rootfs-ext2} $out/share/cartesi-machine/images/rootfs.ext2
  '';
}
