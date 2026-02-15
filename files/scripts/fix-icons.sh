#!/bin/bash
set -e

echo "=== Starting MikuOS Aesthetic Takeover ==="

# --- 1. UNPACK CUSTOM ICONS (CRITICAL NEW STEP) ---
# We must unpack the .tar.xz before we can link anything into it!
if [ -f "/usr/share/icons/Cyan-Breeze-Dark-Icons.tar.xz" ]; then
    echo "Extracting Cyan-Breeze-Dark-Icons..."
    tar -xf /usr/share/icons/Cyan-Breeze-Dark-Icons.tar.xz -C /usr/share/icons/
    rm /usr/share/icons/Cyan-Breeze-Dark-Icons.tar.xz
else
    echo "WARNING: Icon archive not found. Skipping extraction."
fi

# --- 2. ICON VARIABLES ---
MIKU_PNG="/usr/share/icons/hicolor/48x48/apps/start-here.png"
MIKU_SVG="/usr/share/icons/hicolor/scalable/apps/start-here.svg"
TARGET_THEME="/usr/share/icons/Cyan-Breeze-Dark-Icons"

# --- 3. TARGETED FIX FOR NEW THEME ---
# We specifically target your new Cyan set to ensure the Menu Icon works there
if [ -d "$TARGET_THEME" ]; then
    echo "Injecting Miku Logo into Cyan-Breeze..."
    mkdir -p $TARGET_THEME/apps/scalable/
    mkdir -p $TARGET_THEME/places/scalable/
    
    # Link the SVG to the 'start-here-kde' name used by Breeze themes
    ln -sfv $MIKU_SVG $TARGET_THEME/apps/scalable/start-here-kde.svg
    ln -sfv $MIKU_SVG $TARGET_THEME/places/scalable/start-here-kde.svg
    
    # Update the icon cache for this specific theme
    gtk-update-icon-cache $TARGET_THEME || true
fi

# --- 4. EXISTING SHOTGUN LOGIC (KEEPING YOURS) ---
echo "Redirecting all generic 'places' to Miku..."
#Replaces every start-here in every resolution (Good fallback!)
find /usr/share/icons -path "*/places/*" -name "start-here.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -path "*/places/*" -name "start-here.svg" -exec ln -sfv $MIKU_SVG {} \;

# Fix 'fedora-logo-icon'
find /usr/share/icons -name "fedora-logo-icon.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -name "fedora-logo-icon.svg" -exec ln -sfv $MIKU_SVG {} \;

# Fix 'fedora-logos' package
if [ -d "/usr/share/fedora-logos" ]; then
    echo "Sanitizing fedora-logos folder..."
    find /usr/share/fedora-logos -name "*logo*" -exec ln -sfv $MIKU_SVG {} \;
fi

# --- 5. WALLPAPER LOGIC ---
echo "Redirecting Default Wallpapers..."
MIKU_MASTER="/usr/share/wallpapers/MikuOS/contents/images/1920x1080.png"

# A. The Breeze 'Next' Fix (CRITICAL for White Theme)
# This overrides the default mountain wallpaper used by the Breeze Light theme
mkdir -p /usr/share/wallpapers/Next/contents/images/
ln -sfv $MIKU_MASTER /usr/share/wallpapers/Next/contents/images/base.png
ln -sfv $MIKU_MASTER /usr/share/wallpapers/Next/contents/images/1920x1080.png

# B. Your Existing Fedora Workstation Fixes
mkdir -p /usr/share/backgrounds
ln -sfv $MIKU_MASTER /usr/share/backgrounds/default.jxl
ln -sfv $MIKU_MASTER /usr/share/backgrounds/default-dark.jxl

FEDORA_BG_DIR="/usr/share/backgrounds/fedora-workstation"
mkdir -p $FEDORA_BG_DIR
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default.jxl
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default-dark.jxl
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default.png
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default-dark.png

echo "=== MikuOS Takeover Complete ==="
chmod -R 644 /usr/share/fonts/Comfortaa
fc-cache -fv

# ... keep your existing extraction and Miku logo logic ...

# --- THE IDENTITY SWAP ---
# If the system is stubborn and insists on 'breeze', we make breeze a link to Cyan
if [ -d "/usr/share/icons/Cyan-Breeze-Dark-Icons" ]; then
    echo "Performing the Cyan-Breeze Identity Swap..."
    
    # We rename the old breeze folder (safety) and link ours to its name
    # This way, if KDE asks for 'breeze', it gets 'Cyan'
    mv /usr/share/icons/breeze /usr/share/icons/breeze-original || true
    ln -sf /usr/share/icons/Cyan-Breeze-Dark-Icons /usr/share/icons/breeze
fi
