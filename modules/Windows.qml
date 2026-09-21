pragma ComponentBehavior: Bound
import Quickshell.Hyprland
// qmllint disable
import QtQuick

// qmllint enable

import qs.Style

Rectangle {
    id: active_window
    implicitHeight: label.implicitHeight + 8
    implicitWidth: label.implicitWidth + 12
    color: Theme.surface

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.foreground
        text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
    }
}
