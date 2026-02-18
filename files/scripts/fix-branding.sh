#!/usr/bin/env bash
set -xeuo pipefail

# 1. Fix Permissions (Crucial: KDE ignores themes with wrong permissions)
chmod -R 755 /usr/share/plasma/look-and-feel/mikuboot
chmod -R 755 /usr/share/icons/mikursor

# 2. Force Global Defaults
# We write to /etc/xdg because it's the 'system' level for Fedora
mkdir -p /etc/xdg
cat <<EOF > /etc/xdg/kdeglobals
[KDE]
lookAndFeelPackage=mikuboot
cursorTheme=mikursor
EOF

cat <<EOF > /etc/xdg/kcminputrc
[Mouse]
cursorTheme=mikursor
cursorSize=30
[Icons]
Theme=Cyan-Breeze-Dark-Icons
EOF

# 3. System-wide Cursor Fallback (The "Last Resort")
mkdir -p /usr/share/icons/default
echo -e "[Icon Theme]\nInherits=mikursor" > /usr/share/icons/default/index.theme

# 4. FORCE KDE to see the new theme
# This clears the cache so 'lookandfeeltool' sees mikuboot immediately
kbuildsycoca6 --noincremental || true
