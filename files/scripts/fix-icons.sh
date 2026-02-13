#!/bin/bash
set -e

echo "=== Starting MikuOS Aesthetic Takeover ==="

# --- 1. ICON VARIABLES ---
# Ensure these paths match where you put the files in your repo!
MIKU_PNG="/usr/share/icons/hicolor/48x48/apps/start-here.png"
MIKU_SVG="/usr/share/icons/hicolor/scalable/apps/start-here.svg"

# --- 2. ICON LOGIC ---
echo "Redirecting all 'places' to Miku..."

# Fix 'places' (The Taskbar Fix) - Replaces every start-here in every resolution
find /usr/share/icons -path "*/places/*" -name "start-here.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -path "*/places/*" -name "start-here.svg" -exec ln -sfv $MIKU_SVG {} \;

# Fix 'fedora-logo-icon' (The Menu Fix) - Replaces explicit Fedora calls
find /usr/share/icons -name "fedora-logo-icon.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -name "fedora-logo-icon.svg" -exec ln -sfv $MIKU_SVG {} \;

# Fix 'fedora-logos' package (The Safety Net)
# This handles the /usr/share/fedora-logos/ folder if it exists
if [ -d "/usr/share/fedora-logos" ]; then
    echo "Sanitizing fedora-logos folder..."
    find /usr/share/fedora-logos -name "*logo*" -exec ln -sfv $MIKU_SVG {} \;
fi

# Refresh Caches
gtk-update-icon-cache /usr/share/icons/hicolor || true


# --- 3. WALLPAPER LOGIC (JXL/PNG) ---
echo "Redirecting Fedora Defaults to MikuOS Wallpaper..."

# Your Master Miku Image
MIKU_MASTER="/usr/share/wallpapers/MikuOS/contents/images/1920x1080.png"

# Verify the master file actually exists (Prevents broken links if file is missing)
if [ ! -f "$MIKU_MASTER" ]; then
    echo "ERROR: Miku wallpaper not found at $MIKU_MASTER"
    exit 1
fi

# A. Standard Defaults
# We link the PNG to the JXL names to trick Fedora's default settings
mkdir -p /usr/share/backgrounds
ln -sfv $MIKU_MASTER /usr/share/backgrounds/default.jxl
ln -sfv $MIKU_MASTER /usr/share/backgrounds/default-dark.jxl

# B. Fedora Workstation Specifics
# This is the 'Hard-coded' path many Fedora spins use
FEDORA_BG_DIR="/usr/share/backgrounds/fedora-workstation"
mkdir -p $FEDORA_BG_DIR

ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default.jxl
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default-dark.jxl
# Legacy PNG links just in case
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default.png
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default-dark.png

echo "=== MikuOS Takeover Complete ==="
