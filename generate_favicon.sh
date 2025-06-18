#!/bin/bash

# Generate favicon.ico from r.png
# Requires ImageMagick to be installed

echo "Generating favicon.ico from r.png..."

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed."
    echo "Install it using:"
    echo "  macOS: brew install imagemagick"
    echo "  Ubuntu/Debian: sudo apt-get install imagemagick"
    echo "  RHEL/CentOS: sudo yum install ImageMagick"
    exit 1
fi

# Check if r.png exists
if [ ! -f "r.png" ]; then
    echo "Error: r.png not found in current directory"
    exit 1
fi

# Generate favicon.ico with multiple sizes
convert r.png -define icon:auto-resize=64,48,32,16 favicon.ico

if [ $? -eq 0 ]; then
    echo "✓ favicon.ico created successfully!"
    echo "  Contains sizes: 16x16, 32x32, 48x48, 64x64"
else
    echo "✗ Error creating favicon.ico"
    exit 1
fi 