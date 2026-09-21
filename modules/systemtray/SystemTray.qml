pragma ComponentBehavior: Bound
// qmllint disable
import QtQuick
// qmllint enable
import Quickshell
import qs.Style

Rectangle {
    id: root
    required property var panelWindow
    color: Theme.surface
    border.color: Theme.border
    implicitWidth: label.implicitWidth + 12
    implicitHeight: label.implicitHeight + 8
    radius: 4

    property string activePanel: ""   // "" | "wifi" | "bluetooth"
    readonly property int popupWidth: 400

    Text {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: "Ciao"
        color: Theme.foreground
    }

    MouseArea {
        anchors.fill: parent
        onClicked: popup.visible = !popup.visible
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

        grabFocus: true

        implicitWidth: root.popupWidth + 20
        implicitHeight: content.implicitHeight

        Column {
            id: content
            padding: 10
            spacing: 10
            width: root.popupWidth + 20

            UserPower {
                panelWindow: root.panelWindow
                width: root.popupWidth
            }
            Row {
                spacing: 4
                AudioSlider {
                    width: 200
                }
                BrightnessSlider {
                    width: 200
                }
            }

            Row {
                spacing: 4
                WifiTray {
                    id: wifiHeader
                    width: 200
                    expanded: root.activePanel === "wifi"
                    onClicked: root.activePanel = (root.activePanel === "wifi") ? "" : "wifi"
                }
                BluetoothTray {
                    id: btHeader
                    width: 200
                    expanded: root.activePanel === "bluetooth"
                    onClicked: root.activePanel = (root.activePanel === "bluetooth") ? "" : "bluetooth"
                }
            }

            Column {
                width: root.popupWidth
                spacing: 0

                Loader {
                    id: wifiLoader
                    width: root.popupWidth
                    active: wifiHeader.expanded
                    sourceComponent: Component {
                        WifiService {
                            width: root.popupWidth
                            wifiDevice: wifiHeader.wifiDevice
                        }
                    }
                    height: active && item ? item.implicitHeight : 0
                }

                Loader {
                    id: btLoader
                    width: root.popupWidth
                    active: btHeader.expanded
                    sourceComponent: Component {
                        BluetoothService {
                            width: root.popupWidth
                        }
                    }
                    height: active && item ? item.implicitHeight : 0
                }
            }
            Row {
                spacing: 4
                VPNTray {
                    id: vpnHeader
                    width: 200
                    expanded: root.activePanel === "vpn"
                    onClicked: root.activePanel = (root.activePanel === "vpn") ? "" : "vpn"
                }

                AudioTray {
                    id: audioHeader
                    width: 200
                    expanded: root.activePanel === "audio"
                    onClicked: root.activePanel = (root.activePanel === "audio") ? "" : "audio"
                }
            }

            Column {
                width: root.popupWidth
                spacing: 0
                Loader {
                    id: vpnLoader
                    width: root.popupWidth
                    active: vpnHeader.expanded
                    sourceComponent: Component {
                        VPNService {
                            width: root.popupWidth
                            vpns: vpnHeader.vpns
                            onToggled: vpnHeader.refresh()
                        }
                    }
                    height: active && item ? item.implicitHeight : 0
                }

                Loader {
                    id: audioLoader
                    width: root.popupWidth
                    active: audioHeader.expanded
                    sourceComponent: Component {
                        AudioService {
                            width: root.popupWidth
                        }
                    }
                    height: active && item ? item.implicitHeight : 0
                }
            }
        }
    }
}
