// modules/Wifi.qml
pragma ComponentBehavior: Bound
import Quickshell.Networking
// qmllint disable
import QtQuick
// qmllint enable
// import qs.modules

import qs.Style

Column {
    id: root
    required property WifiDevice wifiDevice
    spacing: 2

    Repeater {
        model: root.wifiDevice ? root.wifiDevice.networks : null
        delegate: Rectangle {
            id: netItem
            required property WifiNetwork modelData
            width: root.width
            height: 26
            radius: 4
            color: netItem.modelData.connected ? Theme.selection : "transparent"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 16
                elide: Text.ElideRight
                color: netItem.modelData.connected ? Theme.selectionText : Theme.foreground
                text: netItem.modelData.name + " (" + Math.round(netItem.modelData.signalStrength * 100) + "%)"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: if (!netItem.modelData.connected)
                    netItem.modelData.connect()
            }
        }
    }
}
