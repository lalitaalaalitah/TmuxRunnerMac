#!/usr/bin/env bash
set -e

APP_NAME="TmuxRunner"
APP_DIR="$APP_NAME.app"
BUNDLE_ID="com.user.TmuxRunner"
SRC_FILE="src/main.applescript"

# Default version if not provided via environment
VERSION="${VERSION:-1.2}"
PUBLISHER="lalitaalaalitah"
COPYRIGHT="© $(date +%Y) $PUBLISHER"

echo "Building $APP_NAME v$VERSION..."

# Remove old app if it exists
rm -rf "$APP_DIR"

# Compile AppleScript to a macOS Application Bundle
osacompile -o "$APP_DIR" "$SRC_FILE"

# Insert metadata into Info.plist
echo "Setting App Metadata in Info.plist..."
plutil -insert CFBundleIdentifier -string "$BUNDLE_ID" "$APP_DIR/Contents/Info.plist"
plutil -insert CFBundleShortVersionString -string "$VERSION" "$APP_DIR/Contents/Info.plist"
plutil -insert CFBundleVersion -string "$VERSION" "$APP_DIR/Contents/Info.plist"
plutil -insert NSHumanReadableCopyright -string "$COPYRIGHT" "$APP_DIR/Contents/Info.plist"

echo "Build complete: $APP_DIR"
