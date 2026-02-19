var panel = new Panel
panel.location = "bottom"
panel.height = 44

// This creates the widget list
var widgets = [
    "org.kde.plasma.kickoff", // This is the Start Menu
    "org.kde.plasma.pager",
    "org.kde.plasma.icontasks",
    "org.kde.plasma.marginsseparator",
    "org.kde.plasma.systemtray",
    "org.kde.plasma.digitalclock"
]

panel.newlines = []
for (var i = 0; i < widgets.length; i++) {
    var widget = panel.addWidget(widgets[i])
    
    // If the widget we just added is the Start Menu (Kickoff), change the icon
    if (widgets[i] === "org.kde.plasma.kickoff") {
        widget.currentConfigGroup = ["General"]
        widget.writeConfig("icon", "start-here")
    }
}
