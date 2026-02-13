#!/bin/bash
set -e

# 1. Our Master Source (The Miku icon you already uploaded)
MIKU_PNG="/usr/share/icons/hicolor/48x48/apps/start-here.png"
MIKU_SVG="/usr/share/icons/hicolor/scalable/apps/start-here.svg"

echo "Redirecting all 'places' to Miku..."

# 2. Fix the 'places' folders for every resolution
# This finds every 'start-here' file in ANY 'places' folder and replaces it
find /usr/share/icons -path "*/places/*" -name "start-here.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -path "*/places/*" -name "start-here.svg" -exec ln -sfv $MIKU_SVG {} \;

# 3. Handle the Fedora-specific names we found earlier
# Just in case the system is looking for 'fedora-logo-icon' instead of 'start-here'
find /usr/share/icons -name "fedora-logo-icon.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -name "fedora-logo-icon.svg" -exec ln -sfv $MIKU_SVG {} \;

# 4. Refresh Caches
gtk-update-icon-cache /usr/share/icons/hicolor || true
