{ pkgs, ... }:
{
  src,
  patches ? [ ],
  fixups ? [ ],
  excludeFiles ? [ ],
  name ? "patched-src",
}:

pkgs.stdenvNoCC.mkDerivation {
  inherit name src;

  nativeBuildInputs = [
    pkgs.patch
    pkgs.mergiraf
    pkgs.patchutils
  ];

  phases = [
    "unpackPhase"
    "patchPhase"
    "installPhase"
  ];

  patchPhase = ''
    runHook prePatch

    PATCHES=(${pkgs.lib.escapeShellArgs patches})
    FIXUPS=(${pkgs.lib.escapeShellArgs fixups})
    EXCLUDE_FLAGS=(${pkgs.lib.escapeShellArgs (map (e: "--exclude=*/''${e}") excludeFiles)})

    MARKER_REGEX='<<<<<<<|\|\|\|\|\|\|\||=======|>>>>>>>'

    for p in "''${PATCHES[@]}"; do
      echo "========================================"
      patch_name="$(basename "$p")"
      echo "Applying patch: $patch_name"

      current_patch="$p"
      if [ ''${#EXCLUDE_FLAGS[@]} -gt 0 ]; then
        current_patch="$TMPDIR/filtered_$patch_name"
        filterdiff "''${EXCLUDE_FLAGS[@]}" "$p" > "$current_patch"
        echo "  -> Filtered excluded files from patch stream."
      fi

      if patch -p1 -l --fuzz=0 --merge=diff3 --no-backup-if-mismatch < "$current_patch"; then
        echo "  -> Applied cleanly."
      else
        echo "  -> Conflict detected. Initiating auto-resolution..."

        CONFLICT_FILES=$(grep -rlE "$MARKER_REGEX" . || true)

        if [ -z "$CONFLICT_FILES" ]; then
          echo "Error: Patch failed but no conflict markers were generated."
          exit 1
        fi

        for target_file in $CONFLICT_FILES; do
          echo "    * Resolving collision in: $target_file"

          if mergiraf solve "$target_file"; then
            echo "      [SUCCESS] Mergiraf automatically resolved the collision."
          else
            echo "      [FAILED] Mergiraf could not resolve collision."
            echo "      -> Searching for applicable fixup patches..."

            FIXUP_APPLIED=false
            for f in "''${FIXUPS[@]}"; do
               if patch -p1 -l --fuzz=0 --no-backup-if-mismatch < "$f" >/dev/null 2>&1; then
                  echo "      [SUCCESS] Applied fixup: $(basename "$f")"
                  FIXUP_APPLIED=true
                  break
               fi
            done

            if [ "$FIXUP_APPLIED" = false ]; then
              echo "Error: Exhausted all auto-resolution and fixup options for $target_file."
              exit 1
            fi
          fi
        done

        if grep -rqE "$MARKER_REGEX" . --exclude="*.orig" --exclude="*.rej"; then
          echo "Critical Error: Unresolved conflict markers detected in source files."
          exit 1
        fi
      fi
    done

    runHook postPatch
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -pr . "$out"
  '';
}
