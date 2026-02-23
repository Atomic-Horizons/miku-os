var panel = new Panel
panel.location = "bottom"
panel.height = 44  // This is your magic number
panel.formFactor = "horizontal" // Ensures it behaves as a standard taskbar

// This defines which widgets appear on your MikuOS panel
var widgets = [
    "org.kde.plasma.kickoff",      // Start Menu
    "org.kde.plasma.pager",        // Desktop Cube/Pager
    "org.kde.plasma.icontasks",    // Task Manager (Icons only)
    "org.kde.plasma.marginsseparator",
    "org.kde.plasma.systemtray",   // System Tray (Wifi, Volume, etc)
]

for (var i = 0; i < widgets.length; i++) {
    var widget = panel.addWidget(widgets[i])
    
    // Ensure the Start Menu uses your custom icon name
    if (widgets[i] === "org.kde.plasma.kickoff") {
        widget.currentConfigGroup = ["General"]
        widget.writeConfig("icon", "start-here-kde-symbolic")
    }
}
