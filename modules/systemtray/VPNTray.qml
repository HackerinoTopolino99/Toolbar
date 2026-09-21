// modules/systemtray/VpnHeader.qml
pragma ComponentBehavior: Bound
import Quickshell.Io

// qmllint disable
import QtQuick

// qmllint enable

import qs.Style

Rectangle {
    id: root
    property bool expanded: false
    signal clicked

    color: "transparent"
    height: 32

    property var vpns: []
    readonly property var activeVpns: vpns.filter(v => v.active).map(v => v.name)
    readonly property int activeCount: activeVpns.length

    function refresh() {
        listProc.running = true;
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - 16
        elide: Text.ElideRight
        maximumLineCount: 2
        color: Theme.foreground
        text: {
            let status;
            if (root.activeCount === 0) {
                status = "Not connected";
            } else if (root.activeCount === 1) {
                status = root.activeVpns[0];
            } else {
                status = root.activeVpns[0] + " +" + (root.activeCount - 1);
            }

            return "VPN\n" + status;
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Process {
        id: listProc
        command: ["nmcli", "-t", "-f", "NAME,TYPE,DEVICE", "connection", "show"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n").filter(l => l.length > 0);
                root.vpns = lines.map(l => l.split(":")).filter(p => p[1] === "vpn" || p[1] === "wireguard").map(p => ({
                            name: p[0],
                            type: p[1],
                            active: p[2] !== "--" && p[2] !== ""
                        })).sort((a, b) => a.name.localeCompare(b.name));
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
