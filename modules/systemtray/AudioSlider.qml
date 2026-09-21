// modules/systemtray/AudioSlider.qml
pragma ComponentBehavior: Bound
import Quickshell.Services.Pipewire
// qmllint disable
import QtQuick
import QtQuick.Controls

// qmllint enable

Column {
    id: root
    spacing: 4

    readonly property PwNode sink: Pipewire.defaultAudioSink
    PwObjectTracker {
        objects: [root.sink]
    }

    Text {
        color: "#cdd6f4"
        text: "Volume: " + (root.sink && root.sink.audio ? Math.round(root.sink.audio.volume * 100) : 0) + "%"
    }

    Slider {
        id: volSlider
        width: root.width
        from: 0
        to: 1

        Component.onCompleted: if (root.sink && root.sink.audio)
            value = root.sink.audio.volume

        Connections {
            target: root.sink ? root.sink.audio : null
            function onVolumeChanged() {
                if (!volSlider.pressed)
                    volSlider.value = root.sink.audio.volume;
            }
        }

        onMoved: {
            if (root.sink && root.sink.audio) {
                root.sink.audio.muted = false;
                root.sink.audio.volume = value;
            }
        }
    }
}
