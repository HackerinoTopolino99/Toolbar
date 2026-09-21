// modules/Temperature.qml
import Quickshell
import Quickshell.Io
// qmllint disable
import QtQuick
// qmllint enable

import qs.Style

Rectangle {
    id: root
    required property var panelWindow

    radius: 4
    color: Theme.surface
    implicitWidth: label.implicitWidth + 12
    implicitHeight: label.implicitHeight + 8

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.foreground
        text: "—"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: popup.visible = !popup.visible
    }

    PopupWindow {
        id: popup
        anchor.window: root.panelWindow
        anchor.item: root
        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight
        grabFocus: true

        // qmllint disable
        anchor.edges: Edges.Bottom | Edges.Left
        // qmllint enable
        visible: false
        color: Theme.background

        Column {
            id: content
            padding: 10
            spacing: 6

            Text {
                text: "GPU (NVIDIA)"
                font.bold: true
                color: Theme.bold
            }
            Text {
                text: gpuProc.details
                color: Theme.foreground
            }

            Text {
                text: "NVMe"
                font.bold: true
                color: Theme.bold
            }
            Repeater {
                model: nvmeProc.disks
                delegate: Text {
                    required property var modelData
                    text: modelData.name + ": " + modelData.temp + "°C"
                    color: Theme.foreground
                }
            }
        }
    }

    Process {
        id: cpuProc
        command: ["sensors", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                const data = JSON.parse(text);
                const tctl = data["k10temp-pci-00c3"]?.["Tctl"]?.["temp1_input"];
                label.text = tctl !== undefined ? "CPU " + Math.round(tctl) + "°C" : "N/A";
            }
        }
    }

    Process {
        id: gpuProc
        property string details: "—"
        command: ["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                gpuProc.details = text.trim() + "°C";
            }
        }
    }

    Process {
        id: nvmeProc
        property var disks: []
        command: ["sensors", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                const data = JSON.parse(text);
                const found = [];
                for (const chipName in data) {
                    if (!chipName.startsWith("nvme-"))
                        continue;
                    const chip = data[chipName];
                    for (const fieldName in chip) {
                        const val = chip[fieldName]?.["temp1_input"];
                        if (val !== undefined) {
                            found.push({
                                name: chipName,
                                temp: Math.round(val)
                            });
                        }
                    }
                }
                nvmeProc.disks = found;
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            gpuProc.running = true;
            nvmeProc.running = true;
        }
    }
}
