#!/usr/bin/env bash
set -euo pipefail

SCAD_FILE="billy-ball.scad"
OUT_DIR="models"

mkdir -p "$OUT_DIR"

# Detect binary or flatpak fallback
if command -v openscad >/dev/null 2>&1; then
  OPENSCAD_BIN="openscad"
elif command -v flatpak >/dev/null 2>&1 && flatpak info org.openscad.OpenSCAD >/dev/null 2>&1; then
  OPENSCAD_BIN="flatpak run org.openscad.OpenSCAD"
else
  echo "Error: OpenSCAD is not installed. Run 'sudo apt install openscad' or install the Flatpak." >&2
  exit 1
fi

declare -A PARTS=(
  ["top"]="billy-ball-top.stl"
  ["bottom"]="billy-ball-bottom.stl"
  ["ring"]="billy-ball-ring.stl"
  ["front_ring"]="billy-ball-front-ring.stl"
  ["button"]="billy-ball-button.stl"
  ["filler"]="billy-ball-filler.stl"
  ["chips_black"]="billy-chips-black.stl"
  ["chips_red"]="billy-chips-red.stl"
)

echo "Starting STL builds for $SCAD_FILE using $OPENSCAD_BIN..."

for part in "${!PARTS[@]}"; do
  outfile="$OUT_DIR/${PARTS[$part]}"
  echo "--> Rendering [$part] -> $outfile"
  $OPENSCAD_BIN -o "$outfile" -D "part_to_render=\"$part\"" "$SCAD_FILE"
done

echo "All STLs built in $OUT_DIR/"