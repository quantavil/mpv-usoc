#!/bin/bash
set -e  # Exit immediately if any command fails

# --- Configuration ---
MPV_DIR="$HOME/.config/mpv"
SCRIPTS_DIR="$MPV_DIR/scripts"
OPTS_DIR="$MPV_DIR/script-opts"
FONTS_DIR="$MPV_DIR/fonts"
TEMP_DIR="mpv_install_temp"

# Repositories
UOSC_REPO="tomasklaen/uosc"
THUMBFAST_RAW="https://raw.githubusercontent.com/po5/thumbfast/master"

# Files
MPV_CONF="$MPV_DIR/mpv.conf"
INPUT_CONF="$MPV_DIR/input.conf"

# --- Helper Functions ---
log() { echo -e "\033[1;34m[INFO]\033[0m $1"; }
err() { echo -e "\033[1;31m[ERROR]\033[0m $1"; exit 1; }

download_file() {
    local url="$1"
    local dest="$2"

    log "Downloading $(basename "$dest")..."
    # -o overwrites by default
    if ! curl -s -L "$url" -o "$dest"; then
        err "Failed to download $url"
    fi
}

# --- 1. Dependency Check ---
log "Checking dependencies..."
if ! command -v mpv &> /dev/null || ! command -v jq &> /dev/null; then
    log "Missing dependencies. Installing mpv and jq..."
    sudo dnf install -y mpv jq
fi

# --- 2. Directory Setup ---
log "Preparing directories..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR" "$SCRIPTS_DIR" "$OPTS_DIR" "$FONTS_DIR"

# --- 3. Install uosc (Release Zip) ---
log "Fetching latest uosc release..."
UOSC_URL=$(curl -s "https://api.github.com/repos/$UOSC_REPO/releases/latest" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url')

[ -z "$UOSC_URL" ] || [ "$UOSC_URL" == "null" ] && err "Could not find uosc download URL."

download_file "$UOSC_URL" "$TEMP_DIR/uosc.zip"

log "Extracting and installing uosc..."
unzip -q -o "$TEMP_DIR/uosc.zip" -d "$TEMP_DIR/extracted"
SOURCE_ROOT=$(find "$TEMP_DIR/extracted" -name "scripts" -type d | head -n 1 | xargs dirname)

[ -z "$SOURCE_ROOT" ] && err "Could not find extracted uosc files."

cp -r "$SOURCE_ROOT/scripts/"* "$SCRIPTS_DIR/"
[ -d "$SOURCE_ROOT/fonts" ] && cp -r "$SOURCE_ROOT/fonts/"* "$FONTS_DIR/"

# Install uosc config (Direct Overwrite)
download_file "https://raw.githubusercontent.com/$UOSC_REPO/master/src/uosc.conf" "$OPTS_DIR/uosc.conf"

# --- 4. Install thumbfast (Direct Lua Download) ---
log "Installing thumbfast..."
mkdir -p "$SCRIPTS_DIR/thumbfast"

# Download lua to dedicated folder as main.lua
download_file "$THUMBFAST_RAW/thumbfast.lua" "$SCRIPTS_DIR/thumbfast/main.lua"

# Install thumbfast config (Direct Overwrite)
download_file "$THUMBFAST_RAW/thumbfast.conf" "$OPTS_DIR/thumbfast.conf"

# --- 5. Configure mpv.conf (Append Only) ---
if [ ! -f "$MPV_CONF" ]; then touch "$MPV_CONF"; fi

if ! grep -q "# --- uosc setup ---" "$MPV_CONF"; then
    log "Appending uosc settings to mpv.conf..."
    cat <<EOF >> "$MPV_CONF"

# --- uosc setup ---
osc=no
osd-bar=no
border=no
save-position-on-quit=yes
watch-later-options=start,speed,volume
EOF
else
    log "uosc settings already present in mpv.conf."
fi

# --- 6. Configure input.conf (Append Only) ---
if [ ! -f "$INPUT_CONF" ]; then touch "$INPUT_CONF"; fi

if ! grep -q "# --- uosc specific bindings ---" "$INPUT_CONF"; then
    log "Appending bindings to input.conf..."
    cat <<EOF >> "$INPUT_CONF"

# --- uosc specific bindings ---
p script-binding uosc/items
i vf toggle negate
EOF
else
    log "Bindings already present in input.conf."
fi

# --- 7. Cleanup ---
rm -rf "$TEMP_DIR"
log "Installation complete! Restart mpv to apply changes."
