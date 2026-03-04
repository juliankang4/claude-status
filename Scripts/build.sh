#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

APP_NAME="Claude Status"
BUNDLE_NAME="$APP_NAME.app"
BUILD_DIR="$PROJECT_DIR/Build"
APP_DIR="$BUILD_DIR/$BUNDLE_NAME"

echo "=== Building ClaudeStatus ==="
swift build -c release 2>&1

BINARY=$(swift build -c release --show-bin-path)/ClaudeStatus

echo "=== Creating app bundle ==="
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

cp "$BINARY" "$APP_DIR/Contents/MacOS/ClaudeStatus"
cp "$PROJECT_DIR/Resources/Info.plist" "$APP_DIR/Contents/"
cp "$PROJECT_DIR/Resources/AppIcon.icns" "$APP_DIR/Contents/Resources/"
cp "$PROJECT_DIR/Resources/claude-logo.svg" "$APP_DIR/Contents/Resources/"

echo "=== Ad-hoc signing ==="
codesign --force --sign - "$APP_DIR/Contents/MacOS/ClaudeStatus"
codesign --force --sign - "$APP_DIR"

echo "=== Done ==="
echo "App bundle: $APP_DIR"

if [ "$1" = "--install" ]; then
    echo "=== Installing to /Applications ==="
    rm -rf "/Applications/$BUNDLE_NAME"
    cp -R "$APP_DIR" "/Applications/$BUNDLE_NAME"
    echo "Installed to /Applications/$BUNDLE_NAME"
fi
