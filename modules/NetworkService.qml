// modules/Networking.qml
pragma ComponentBehavior: Bound
import Quickshell.Networking
// qmllint disable
import QtQuick
// qmllint enable
import Quickshell
import Quickshell.Io

import qs.Style

Rectangle {
    id: root
    required property var panelWindow

    // Non esiste un vero "defaultDevice" in Quickshell.Networking:
    // approssimiamo prendendo il primo device connesso della lista.
    readonly property NetworkDevice defaultDevice: {
        for (const dev of Networking.devices.values) {
            if (dev.connected)
                return dev;
        }
        return null;
    }

    color: Theme.surface
    radius: 4
    implicitWidth: label.implicitWidth + 12
    implicitHeight: label.implicitHeight + 8

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.foreground
        text: root.defaultDevice ? root.defaultDevice.name : "No network"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: popup.visible = !popup.visible
    }

    readonly property var managedNames: {
        const names = [];
        for (const dev of Networking.devices.values)
            names.push(dev.name);
        return names;
    }

    property var externalDevices: []
    property var ipByIface: ({})

    Process {
        id: ipProc
        command: ["ip", "-j", "addr"]
        stdout: StdioCollector {
            onStreamFinished: {
                const ifaces = JSON.parse(text);
                const map = {};
                for (const iface of ifaces) {
                    map[iface.ifname] = (iface.addr_info || []).filter(a => a.family === "inet").map(a => a.local + "/" + a.prefixlen);
                }
                root.ipByIface = map;
                root.externalDevices = ifaces.filter(i => i.ifname !== "lo" && !root.managedNames.includes(i.ifname) && !i.ifname.startsWith("veth") && !i.ifname.endsWith("-mtu")).map(i => ({
                            ifname: i.ifname,
                            addresses: map[i.ifname] || []
                        }));
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: ipProc.running = true
    }

    PopupWindow {
        id: popup
        anchor.window: root.panelWindow
        anchor.item: root
        // qmllint disable missing-type
        anchor.edges: Edges.Bottom | Edges.Left
        // qmllint enable missing-type
        visible: false
        color: Theme.background

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        Column {
            id: content
            padding: 10
            spacing: 10

            Repeater {
                id: repeater
                model: Networking.devices

                delegate: Column {
                    id: device
                    required property var modelData
                    spacing: 5

                    Text {
                        text: device.modelData.name + ": " + (root.ipByIface[device.modelData.name] || []).join(", ") || "nessun IP"
                        color: Theme.foreground
                    }
                }
            }

            Repeater {
                id: repeater_external
                model: root.externalDevices

                delegate: Column {
                    id: extDevice
                    required property var modelData
                    spacing: 5

                    Text {
                        text: extDevice.modelData.ifname + ": " + extDevice.modelData.addresses.join(", ") || "nessun IP"
                        color: Theme.foreground
                    }
                }
            }
        }
    }
}
