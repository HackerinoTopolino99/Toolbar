//@ pragma UseQApplication

// ~/.config/quickshell/shell.qml
import Quickshell
// qmllint disable
import QtQuick
// qmllint enable
import Quickshell.Hyprland

import qs.modules
import qs.modules.systemtray
import qs.Style

ShellRoot {
    Variants {
        model: Quickshell.screens
        // qmllint disable uncreatable-type
        PanelWindow {
            // qmllint enable uncreatable-type
            id: panel
            required property var modelData
            screen: panel.modelData

            readonly property HyprlandMonitor monitor: Hyprland.monitorFor(panel.screen)
            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: Theme.background

            Item {
                anchors.fill: parent

                Row {
                    id: leftBlock
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    Workspaces {
                        panelWindow: panel
                    }
                }

                Row {
                    id: centerBlock
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    Windows {}
                }

                Row {
                    id: rightBlock
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    spacing: 4
                    Resources {
                        panelWindow: panel
                    }
                    Temperature {
                        panelWindow: panel
                    }
                    Tray {
                        panelWindow: panel
                    }
                    NetworkService {
                        panelWindow: panel
                    }
                    Clock {}
                    SystemTray {
                        panelWindow: panel
                    }
                }
            }
        }
    }
}
