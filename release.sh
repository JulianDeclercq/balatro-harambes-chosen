#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

CURRENT_DIR=$(pwd)
TEMP_DIR=$(mktemp -d)
DEST_DIR="$TEMP_DIR/harambeschosen"

mkdir -p "$DEST_DIR"
cp -r localization "$DEST_DIR/"
cp main.lua "$DEST_DIR/"

mkdir -p "$DEST_DIR/assets"
rsync -av --exclude='originals' assets/ "$DEST_DIR/assets/"

(
	cd "$TEMP_DIR"
	zip -r "$CURRENT_DIR/harambeschosen.zip" harambeschosen
)

rm -rf "$TEMP_DIR"
