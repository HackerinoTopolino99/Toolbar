// modules/ResourceUsage.qml
import Quickshell.Io
// qmllint disable
import QtQuick

// qmllint enable

import Quickshell
import qs.Style

Rectangle {
    id: root
    required property var panelWindow

    radius: 4
    color: Theme.surface

    implicitWidth: label.implicitWidth + 12
    implicitHeight: label.implicitHeight + 8

    property real cpuUsage: 0
    property real ramUsage: 0
    property string diskUsed: "—"
    property var prevCpu: null

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.foreground
        text: "CPU: " + root.cpuUsage.toFixed(1) + "%"
    }

    // ----- CPU (/proc/stat, richiede due letture per fare il delta) -----
    FileView {
        id: statFile
        path: "/proc/stat"
    }

    function parseCpuLine(text) {
        const line = text.split("\n")[0];
        const parts = line.trim().split(/\s+/).slice(1).map(Number);
        const idle = parts[3] + parts[4]; // idle + iowait
        const total = parts.reduce((a, b) => a + b, 0);
        return {
            idle,
            total
        };
    }

    function updateCpu() {
        statFile.reload();
        const cur = parseCpuLine(statFile.text());
        if (root.prevCpu) {
            const idleDelta = cur.idle - root.prevCpu.idle;
            const totalDelta = cur.total - root.prevCpu.total;
            root.cpuUsage = totalDelta > 0 ? (1 - idleDelta / totalDelta) * 100 : 0;
        }
        root.prevCpu = cur;
    }

    // ----- RAM (/proc/meminfo, lettura singola) -----
    FileView {
        id: memFile
        path: "/proc/meminfo"
    }

    function updateRam() {
        memFile.reload();
        const lines = memFile.text().split("\n");
        const map = {};
        for (const l of lines) {
            const m = l.match(/^(\w+):\s+(\d+)/);
            if (m)
                map[m[1]] = parseInt(m[2]);
        }
        if (map.MemTotal && map.MemAvailable) {
            root.ramUsage = (1 - map.MemAvailable / map.MemTotal) * 100;
        }
    }

    // ----- Disco (df, già in formato leggibile) -----
    Process {
        id: diskProc
        command: ["df", "-h", "--output=pcent", "/"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length >= 2) {
                    const parts = lines[1].trim().split(/\s+/);
                    root.diskUsed = parts[0];
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.updateCpu();
            root.updateRam();
            diskProc.running = true;
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            popup.visible = !popup.visible;
        }
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
        // color: Theme.elevated
        grabFocus: true

        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        Column {
            id: content
            padding: 10
            spacing: 6

            Text {
                text: "CPU: " + root.cpuUsage.toFixed(1) + "%"
                color: Theme.foreground
            }
            Text {
                text: "RAM: " + root.ramUsage.toFixed(1) + "%"
                color: Theme.foreground
            }
            Text {
                text: "Disk (/): " + root.diskUsed
                color: Theme.foreground
            }
        }
    }
}
