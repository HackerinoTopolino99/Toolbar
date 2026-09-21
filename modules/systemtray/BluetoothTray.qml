pragma ComponentBehavior: Bound
import Quickshell.Bluetooth
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

    // qmllint disable
    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    // qmllint enable

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - 16
        elide: Text.ElideRight
        color: Theme.foreground
        text: root.adapter ? root.adapter.adapterId : "No BT"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
