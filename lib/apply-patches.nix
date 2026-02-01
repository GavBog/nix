{ pkgs }:
{
  src,
  patches ? [ ],
  fixups ? [ ],
  name ? "patched-src",
}:

pkgs.stdenvNoCC.mkDerivation {
  inherit name src;

  nativeBuildInputs = [
    pkgs.git
    pkgs.mergiraf
  ];

  phases = [
    "unpackPhase"
    "patchPhase"
    "installPhase"
  ];

  patchPhase = ''
    runHook prePatch

    git init
    git config user.email "builder@nixos.org"
    git config user.name "nix-builder"
    git config merge.conflictStyle diff3

    git config merge.mergiraf.name "mergiraf"
    git config merge.mergiraf.driver "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P -l %L"
    echo "* merge=mergiraf" > .git/info/attributes

    git add .
    git commit -m "base"

    FIXUPS=( ${pkgs.lib.concatMapStringsSep " " (f: "\"${f}\"") fixups} )
    PATCHES=( ${pkgs.lib.concatMapStringsSep " " (p: "\"${p}\"") patches} )

    for p in "''${PATCHES[@]}"; do
      echo "Applying patch: $p"
      if git am --3way --whitespace=nowarn "$p"; then
        echo "  -> Applied cleanly (or resolved by mergiraf)."
      else
        echo "  -> Conflict detected. Attempting to resolve with fixups..."

        for f in "''${FIXUPS[@]}"; do
           git apply --ignore-whitespace "$f" >/dev/null 2>&1 || true
        done
        
        git add .

        if git am --continue; then
          echo "  -> Resolved successfully via fixups."
        else
          echo "Error: Fixups could not resolve the conflict in $p."
          exit 1
        fi
      fi
    done

    runHook postPatch
  '';

  installPhase = ''
    rm -rf .git
    mkdir -p $out
    cp -pr . $out
  '';
}
