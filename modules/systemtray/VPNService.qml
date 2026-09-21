// modules/systemtray/VPNService.qml
pragma ComponentBehavior: Bound
import Quickshell.Io

// qmllint disable
import QtQuick
// qmllint enable
import qs.Style

Column {
    id: root
    required property var vpns
    property var onToggled: function () {}
    spacing: 2

    function toggle(vpn) {
        toggleProc.command = vpn.active ? ["nmcli", "connection", "down", vpn.name] : ["nmcli", "connection", "up", vpn.name];
        toggleProc.running = true;
    }

    Process {
        id: toggleProc
        stdout: StdioCollector {
            onStreamFinished: root.onToggled()
        }
    }

    Repeater {
        model: root.vpns
        delegate: Rectangle {
            id: vpnItem
            required property var modelData
            width: root.width
            height: 26
            radius: 4
            color: vpnItem.modelData.active ? Theme.selection : "transparent"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 16
                elide: Text.ElideRight
                color: vpnItem.modelData.active ? Theme.selectionText : Theme.foreground
                text: vpnItem.modelData.name + (vpnItem.modelData.active ? " ✓" : "")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.toggle(vpnItem.modelData)
            }
        }
    }
}
