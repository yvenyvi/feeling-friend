#!/bin/bash

# Exit on error
set -e

echo "Downloading Flutter SDK..."
if [ -d "flutter" ]; then
    echo "Flutter directory already exists."
else
    git clone https://github.com/flutter/flutter.git -b stable
fi

export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Enabling web support..."
flutter config --enable-web

echo "Getting packages..."
flutter pub get

echo "Building web app..."
flutter build web --release

echo "Build complete."
