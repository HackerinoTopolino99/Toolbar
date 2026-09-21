// modules/BluetoothService.qml
pragma ComponentBehavior: Bound
import Quickshell.Bluetooth
// qmllint disable
import QtQuick

// qmllint enable

import qs.Style

Column {
    id: root
    spacing: 2

    Repeater {
        // qmllint disable
        model: Bluetooth.adapters
        // qmllint enable

        delegate: Column {
            id: adapterCol
            required property var modelData
            width: root.width
            spacing: 2

            Repeater {
                model: adapterCol.modelData.devices

                delegate: Rectangle {
                    id: devItem
                    required property var modelData
                    visible: devItem.modelData.paired
                    width: adapterCol.width
                    height: devItem.visible ? 26 : 0
                    radius: 4
                    color: devItem.modelData.connected ? Theme.selection : "transparent"

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 16
                        elide: Text.ElideRight
                        color: devItem.modelData.connected ? Theme.selectionText : Theme.foreground
                        text: devItem.modelData.name !== "" ? devItem.modelData.name : devItem.modelData.address
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (devItem.modelData.connected)
                                devItem.modelData.disconnectDevice();
                            else
                                devItem.modelData.connectDevice();
                        }
                    }
                }
            }
        }
    }
}
