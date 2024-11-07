#!/bin/bash

# Create icons directory if it doesn't exist
mkdir -p public/images/icons

# List of required sizes
SIZES=(72 96 128 144 152 192 384 512)

# Generate icons for each size
for size in "${SIZES[@]}"; do
    inkscape -w $size -h $size public/images/icons/icon-source.svg -o public/images/icons/icon-${size}x${size}.png
done

# Generate Microsoft tile icons
MS_SIZES=(70 150 310)
for size in "${MS_SIZES[@]}"; do
    inkscape -w $size -h $size public/images/icons/icon-source.svg -o public/images/icons/ms-icon-${size}x${size}.png
done

# Generate favicon
inkscape -w 32 -h 32 public/images/icons/icon-source.svg -o public/favicon.ico 