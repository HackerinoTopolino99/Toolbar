// qmllint disable
import QtQuick

// qmllint enable

import qs.Style

Rectangle {
    id: root
    color: Theme.surface
    implicitWidth: label.implicitWidth + 12
    implicitHeight: label.implicitHeight + 8
    radius: 4

    Text {
        id: label
        anchors.centerIn: parent
        property bool showDate: false
        property var currentTime: new Date()

        // Il testo si aggiorna automaticamente se showDate o currentTime cambiano
        text: showDate ? Qt.formatDate(currentTime, "dd/MM/yyyy") : Qt.formatTime(currentTime, "hh:mm:ss")
        font.pixelSize: 14
        color: Theme.foreground

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: label.currentTime = new Date()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: label.showDate = !label.showDate
        }
    }
}
