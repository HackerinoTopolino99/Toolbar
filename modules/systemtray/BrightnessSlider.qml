// modules/systemtray/BrightnessSlider.qml
pragma ComponentBehavior: Bound
import Quickshell.Io
// qmllint disable
import QtQuick
import QtQuick.Controls

// qmllint enable

Column {
    id: root
    spacing: 4

    property int percent: 0

    Text {
        color: "#cdd6f4"
        text: "Luminosità: " + root.percent + "%"
    }

    Slider {
        id: brightSlider
        width: root.width
        from: 0
        to: 100

        Component.onCompleted: value = root.percent

        onValueChanged: if (!pressed && !brightSlider.pressed) {
            // sincronizza solo se il valore arriva da fuori, non dal drag
        }

        onMoved: setProc.command = ["brightnessctl", "set", Math.round(value) + "%"]
        onPressedChanged: if (!pressed)
            setProc.running = true
    }

    Process {
        id: getProc
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                // formato: device,class,current,percent%,max
                const parts = text.trim().split(",");
                if (parts.length >= 4) {
                    const pct = parseInt(parts[3]);
                    root.percent = pct;
                    if (!brightSlider.pressed)
                        brightSlider.value = pct;
                }
            }
        }
    }

    Process {
        id: setProc
        stdout: StdioCollector {
            onStreamFinished: getProc.running = true
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!brightSlider.pressed)
            getProc.running = true
    }
}
