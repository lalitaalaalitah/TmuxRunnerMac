#!/usr/bin/env bash
set -e

APP_NAME="TmuxRunner.app"
DEST_DIR="$HOME/Applications"
BUNDLE_ID="com.user.TmuxRunner"

if [ ! -d "$APP_NAME" ]; then
    echo "App not built yet. Run ./build.sh first."
    exit 1
fi

echo "Installing $APP_NAME to $DEST_DIR..."
mkdir -p "$DEST_DIR"
cp -r "$APP_NAME" "$DEST_DIR/"

echo "Registering app with LaunchServices..."
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "$DEST_DIR/$APP_NAME"

echo "Setting default file associations using duti..."
if command -v duti >/dev/null 2>&1; then
    duti -s "$BUNDLE_ID" public.shell-script all
    duti -s "$BUNDLE_ID" com.apple.terminal.shell-script all
    echo "Successfully set TmuxRunner as default for .sh and .command files."
else
    echo "Error: duti is not installed or not in PATH."
    echo "Install duti (e.g. 'brew install duti' or via Nix) and run this script again."
    exit 1
fi
