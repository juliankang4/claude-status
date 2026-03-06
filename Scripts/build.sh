#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

APP_NAME="Claude Status"
BUNDLE_NAME="$APP_NAME.app"
BUILD_DIR="$PROJECT_DIR/Build"
APP_DIR="$BUILD_DIR/$BUNDLE_NAME"
DERIVED_DATA="$PROJECT_DIR/.build/DerivedData"

# Check if xcodegen + Xcode are available
if command -v xcodegen &>/dev/null && command -v xcodebuild &>/dev/null && xcodebuild -version &>/dev/null 2>&1; then
    echo "=== Building with xcodebuild (widget included) ==="
    xcodegen generate
    xcodebuild -project ClaudeStatus.xcodeproj \
        -scheme ClaudeStatus \
        -configuration Release \
        -derivedDataPath "$DERIVED_DATA" \
        CODE_SIGN_IDENTITY="-" \
        CODE_SIGN_STYLE=Manual \
        OTHER_CODE_SIGN_FLAGS="--deep" \
        build

    BUILT_APP="$DERIVED_DATA/Build/Products/Release/ClaudeStatus.app"

    echo "=== Copying to Build/ ==="
    rm -rf "$APP_DIR"
    mkdir -p "$BUILD_DIR"
    cp -R "$BUILT_APP" "$APP_DIR"

    # Add resources if missing
    mkdir -p "$APP_DIR/Contents/Resources"
    cp -n "$PROJECT_DIR/Resources/AppIcon.icns" "$APP_DIR/Contents/Resources/" 2>/dev/null || true
    cp -n "$PROJECT_DIR/Resources/claude-logo.svg" "$APP_DIR/Contents/Resources/" 2>/dev/null || true
else
    echo "=== Building with swift build (main app only, no widget) ==="
    BIN_PATH=$(swift build -c release --show-bin-path)
    BINARY="$BIN_PATH/ClaudeStatus"

    rm -rf "$APP_DIR"
    mkdir -p "$APP_DIR/Contents/MacOS"
    mkdir -p "$APP_DIR/Contents/Resources"

    cp "$BINARY" "$APP_DIR/Contents/MacOS/ClaudeStatus"
    cp "$PROJECT_DIR/Resources/Info.plist" "$APP_DIR/Contents/"
    cp "$PROJECT_DIR/Resources/AppIcon.icns" "$APP_DIR/Contents/Resources/"
    cp "$PROJECT_DIR/Resources/claude-logo.svg" "$APP_DIR/Contents/Resources/"

    codesign --force --deep --sign - "$APP_DIR"
fi

echo "=== Done ==="
echo "App bundle: $APP_DIR"

if [ "$1" = "--install" ]; then
    echo "=== Installing to /Applications ==="
    rm -rf "/Applications/$BUNDLE_NAME"
    cp -R "$APP_DIR" "/Applications/$BUNDLE_NAME"
    echo "Installed to /Applications/$BUNDLE_NAME"
fi
