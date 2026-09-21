// modules/systemtray/UserPower.qml
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
// qmllint disable
import QtQuick
// qmllint enable
import qs.Style

Item {
    id: root
    required property var panelWindow
    height: 32

    readonly property string username: Quickshell.env("USER") || "user"
    readonly property string avatarPath: Quickshell.env("HOME") + "/.face"

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Rectangle {
            id: avatarFrame
            width: 24
            height: 24
            radius: width / 2
            color: "#1e1e2e"
            clip: true

            Image {
                anchors.fill: parent
                source: "file://" + root.avatarPath
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                onStatusChanged: if (status === Image.Error)
                    source = Quickshell.iconPath("avatar-default")
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: "#cdd6f4"
            text: root.username
        }
    }

    Rectangle {
        id: powerBtn
        width: 22
        height: 22
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        radius: 4
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: "⏻"
            color: "#f38ba8"
            font.pixelSize: 16
        }

        MouseArea {
            anchors.fill: parent
            onClicked: popup.visible = !popup.visible
        }

        PopupWindow {
            id: popup
            anchor.window: root.panelWindow
            anchor.item: powerBtn
            // qmllint disable missing-type
            anchor.edges: Edges.Bottom | Edges.Right
            // qmllint enable missing-type
            visible: false
            color: Theme.background
            grabFocus: true

            implicitWidth: menu.implicitWidth + 20
            implicitHeight: menu.implicitHeight + 20

            Column {
                id: menu
                padding: 10
                spacing: 4

                Rectangle {
                    width: 140
                    height: 30
                    radius: 4
                    color: "transparent"
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#cdd6f4"
                        text: "⏻  Spegni"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            popup.visible = false;
                            shutdownProc.running = true;
                        }
                    }
                }

                Rectangle {
                    width: 140
                    height: 30
                    radius: 4
                    color: "transparent"
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#cdd6f4"
                        text: "⟳  Riavvia"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            popup.visible = false;
                            rebootProc.running = true;
                        }
                    }
                }
            }
        }

        Process {
            id: shutdownProc
            command: ["systemctl", "poweroff"]
        }
        Process {
            id: rebootProc
            command: ["systemctl", "reboot"]
        }
    }
}
