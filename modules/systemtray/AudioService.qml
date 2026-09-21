// modules/systemtray/AudioService.qml
pragma ComponentBehavior: Bound
import Quickshell.Services.Pipewire
// qmllint disable
import QtQuick
// qmllint enable
import qs.Style

Column {
    id: root
    spacing: 2

    Repeater {
        model: Pipewire.nodes

        delegate: Rectangle {
            id: sinkItem
            required property PwNode modelData

            // solo dispositivi di output hardware, non stream applicativi
            visible: sinkItem.modelData.isSink && !sinkItem.modelData.isStream && sinkItem.modelData.audio !== null
            width: root.width
            height: visible ? 26 : 0
            radius: 4
            color: sinkItem.modelData === Pipewire.defaultAudioSink ? Theme.selection : "transparent"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 16
                elide: Text.ElideRight
                color: sinkItem.modelData === Pipewire.defaultAudioSink ? Theme.selectionText : Theme.foreground
                text: sinkItem.modelData.description || sinkItem.modelData.name
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Pipewire.preferredDefaultAudioSink = sinkItem.modelData
            }
        }
    }
}
