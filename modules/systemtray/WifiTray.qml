pragma ComponentBehavior: Bound
import Quickshell.Networking
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

    readonly property WifiDevice wifiDevice: {
        for (const dev of Networking.devices.values) {
            if (dev.type === DeviceType.Wifi)
                return dev;
        }
        return null;
    }
    readonly property Network connectedNetwork: {
        if (!wifiDevice)
            return null;
        for (const net of wifiDevice.networks.values) {
            if (net.connected)
                return net;
        }
        return null;
    }

    onExpandedChanged: if (wifiDevice)
        wifiDevice.scannerEnabled = expanded

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - 16
        elide: Text.ElideRight
        color: Theme.foreground
        text: root.connectedNetwork ? root.connectedNetwork.name : "Non connesso"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
