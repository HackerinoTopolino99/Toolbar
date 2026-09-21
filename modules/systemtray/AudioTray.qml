// modules/systemtray/AudioHeader.qml
pragma ComponentBehavior: Bound
import Quickshell.Services.Pipewire

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

    readonly property PwNode sink: Pipewire.defaultAudioSink

    // tiene "vivo" e aggiornato il riferimento al sink corrente
    PwObjectTracker {
        objects: [root.sink]
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - 16
        elide: Text.ElideRight
        color: Theme.foreground
        text: root.sink ? (root.sink.description || root.sink.name) : "Nessuna uscita"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
