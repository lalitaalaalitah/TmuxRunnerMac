#!/usr/bin/env bash
set -e

APP_NAME="TmuxRunner"
APP_DIR="$APP_NAME.app"
BUNDLE_ID="com.user.TmuxRunner"
SRC_FILE="src/main.applescript"

echo "Building $APP_NAME..."

# Remove old app if it exists
rm -rf "$APP_DIR"

# Compile AppleScript to a macOS Application Bundle
osacompile -o "$APP_DIR" "$SRC_FILE"

# Insert CFBundleIdentifier into Info.plist so duti can target it
echo "Setting CFBundleIdentifier to $BUNDLE_ID..."
plutil -insert CFBundleIdentifier -string "$BUNDLE_ID" "$APP_DIR/Contents/Info.plist"

echo "Build complete: $APP_DIR"
