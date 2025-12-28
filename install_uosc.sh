#!/bin/bash
set -e  # Exit immediately if any command fails

# --- Variables ---
MPV_DIR="$HOME/.config/mpv"
TEMP_DIR="uosc_temp"
UOSC_OPTS_DIR="$MPV_DIR/script-opts"
GITHUB_REPO="tomasklaen/uosc"
MPV_CONF="$MPV_DIR/mpv.conf"
INPUT_CONF="$MPV_DIR/input.conf"

# --- 1. Dependency Check ---
echo "Checking dependencies..."
if ! command -v mpv &> /dev/null || ! command -v jq &> /dev/null; then
    echo "Missing dependencies. Installing mpv and jq..."
    sudo dnf install -y mpv jq
else
    echo "Dependencies (mpv, jq) are present."
fi

# --- 2. Directory Setup ---
echo "Preparing directories..."
rm -rf "$TEMP_DIR" # Clean start
mkdir -p "$TEMP_DIR"
mkdir -p "$MPV_DIR/scripts"
mkdir -p "$UOSC_OPTS_DIR"
mkdir -p "$MPV_DIR/fonts"

# --- 3. Download Latest Release ---
echo "Fetching latest release URL..."
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/releases/latest" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url')

if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" == "null" ]; then
    echo "Error: Could not find download URL."
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Downloading uosc package..."
curl -L -o "$TEMP_DIR/uosc.zip" "$DOWNLOAD_URL"

# --- 4. Smart Extraction & Installation ---
echo "Extracting..."
unzip -o "$TEMP_DIR/uosc.zip" -d "$TEMP_DIR/extracted" > /dev/null

# Dynamic Path Detection
FOUND_SCRIPTS=$(find "$TEMP_DIR/extracted" -name "scripts" -type d | head -n 1)

if [ -z "$FOUND_SCRIPTS" ]; then
    echo "Error: 'scripts' folder not found in the downloaded zip."
    rm -rf "$TEMP_DIR"
    exit 1
fi

SOURCE_ROOT=$(dirname "$FOUND_SCRIPTS")
echo "Found source files in: $SOURCE_ROOT"

# Install Scripts
echo "Installing scripts..."
cp -r "$SOURCE_ROOT/scripts/"* "$MPV_DIR/scripts/"

# Install Fonts (Safety Check)
if [ -d "$SOURCE_ROOT/fonts" ]; then
    echo "Installing fonts..."
    cp -r "$SOURCE_ROOT/fonts/"* "$MPV_DIR/fonts/"
else
    echo "Warning: fonts directory not found in source, skipping font installation."
fi

# Post-Install Verification (UPDATED FOR v5+)
if [ -f "$MPV_DIR/scripts/uosc/main.lua" ]; then
    echo "Verified: uosc (package mode) installed successfully."
elif [ -f "$MPV_DIR/scripts/uosc.lua" ]; then
    echo "Verified: uosc (legacy mode) installed successfully."
else
    echo "Error: uosc installation failed. Could not find 'scripts/uosc/main.lua'."
    rm -rf "$TEMP_DIR"
    exit 1
fi

# --- 5. Download & Install Config ---
echo "Downloading default uosc.conf..."
curl -s -L "https://raw.githubusercontent.com/tomasklaen/uosc/master/src/uosc.conf" -o "$UOSC_OPTS_DIR/uosc.conf"

# --- 6. Configure mpv.conf (Idempotent) ---
echo "Configuring mpv.conf..."
if [ ! -f "$MPV_CONF" ]; then touch "$MPV_CONF"; fi

if ! grep -q "# --- uosc setup ---" "$MPV_CONF"; then
    cat <<EOF >> "$MPV_CONF"

# --- uosc setup ---
# Disable default UI for uosc
osc=no
osd-bar=no
border=no

# Persistence settings
save-position-on-quit=yes
watch-later-options=start,speed,volume
EOF
    echo "Added uosc settings to mpv.conf."
else
    echo "uosc settings already detected in mpv.conf. Skipping."
fi

# --- 7. Configure input.conf (Idempotent) ---
echo "Configuring input.conf..."
if [ ! -f "$INPUT_CONF" ]; then touch "$INPUT_CONF"; fi

if ! grep -q "# --- uosc specific bindings ---" "$INPUT_CONF"; then
    cat <<EOF >> "$INPUT_CONF"

# --- uosc specific bindings ---
# Opens unified menu for Playlist and File Browser
p script-binding uosc/items

# --- Video Filters ---
# Toggle Invert Colors (Negate)
i vf toggle negate
EOF
    echo "Added keybindings to input.conf."
else
    echo "Keybindings already detected in input.conf. Skipping."
fi

# --- 8. Cleanup ---
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo "Success! uosc has been installed and configured."
