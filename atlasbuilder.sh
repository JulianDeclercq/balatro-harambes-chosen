#!/bin/bash

# Check if 'convert' command (a part of ImageMagick) is available
if ! command -v convert &> /dev/null; then
  echo "Error: ImageMagick is not installed. Please install it and try again."
  exit 1
fi

montage assets/originals/*.png -background none -tile x1 -geometry +0+0 assets/2x/harambe_jokers.png
convert assets/2x/harambe_jokers.png -resize 50% assets/1x/harambe_jokers.png
