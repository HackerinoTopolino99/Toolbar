pragma ComponentBehavior: Bound
import Quickshell.Hyprland
// qmllint disable
import QtQuick

// qmllint enable

import "../Style"

Row {
    id: hyprlandWorkspaces
    required property var panelWindow
    spacing: 4

    Repeater {
        id: repeater
        model: Hyprland.workspaces.values.filter(ws => ws.monitor === hyprlandWorkspaces.panelWindow.monitor && ws.id > 0)

        delegate: Rectangle {
            id: workspace
            required property var modelData
            radius: 4
            color: workspace.modelData.active ? Theme.selection : Theme.surface
            width: label.implicitWidth + 12
            height: label.implicitHeight + 8

            Text {
                id: label
                anchors.centerIn: parent
                text: workspace.modelData.id + ": " + workspace.modelData.name
                color: workspace.modelData.active ? Theme.selectionText : Theme.foreground
            }

            MouseArea {
                anchors.fill: parent
                onClicked: workspace.modelData.activate()
            }
        }
    }
}
