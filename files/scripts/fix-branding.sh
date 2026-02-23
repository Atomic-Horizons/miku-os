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

# 4. FORCE GLOBAL PANEL TEMPLATE (The Plasma 6 44px Fix)
# Overwrite the default Plasma 6 layout.js so every new panel is exactly 44px
MASTER_TEMPLATE="/usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js"

cat << 'EOF' > "$MASTER_TEMPLATE"
var panel = new Panel
panel.location = "bottom"
panel.height = 44

var widgets = [
    "org.kde.plasma.kickoff",
    "org.kde.plasma.pager",
    "org.kde.plasma.icontasks",
    "org.kde.plasma.marginsseparator",
    "org.kde.plasma.systemtray",
    "org.kde.plasma.digitalclock"
]

for (var i = 0; i < widgets.length; i++) {
    var widget = panel.addWidget(widgets[i])
    if (widgets[i] === "org.kde.plasma.kickoff") {
        widget.currentConfigGroup = ["General"]
        widget.writeConfig("icon", "start-here-kde-symbolic")
    }
}
EOF

# Ensure the system has permission to read the patched template
chmod 644 "$MASTER_TEMPLATE"

# 5. FORCE KDE to see the new theme
# This clears the cache so 'lookandfeeltool' sees mikuboot immediately
kbuildsycoca6 --noincremental || true
