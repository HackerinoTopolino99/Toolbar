import Quickshell
import Quickshell.Services.Notifications
// qmllint disable
import QtQuick
// qmllint enable
import QtQuick.Layouts

NotificationServer {
    id: server

    property Component popupComponent: Component {
        // qmllint disable uncreatable-type
        PanelWindow {
            // qmllint enable uncreatable-type
            id: popup
            required property Notification notif
            screen: Quickshell.screens[0]

            anchors {
                top: true
                right: true
            }
            margins {
                top: 8
                right: 8
            }

            width: 300
            implicitHeight: content.implicitHeight + 20
            color: "#313244"

            RowLayout {
                id: content
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: 10
                }
                spacing: 10

                Image {
                    id: icon
                    source: popup.notif.appIcon.length > 0
                            ? "image://icon/" + popup.notif.appIcon
                            : (popup.notif.image.length > 0
                               ? popup.notif.image
                               : "image://icon/dialog-information")
                    sourceSize.width: 48
                    sourceSize.height: 48
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: popup.notif.summary
                        color: "#cdd6f4"
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        visible: popup.notif.body.length > 0
                        text: popup.notif.body
                        color: "#a6adc8"
                        wrapMode: Text.Wrap
                    }
                }
            }

            Timer {
                running: true
                repeat: false
                interval: popup.notif.expireTimeout > 0 ? popup.notif.expireTimeout : 5000
                onTriggered: popup.destroy()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: popup.destroy()
            }
        }
    }

    onNotification: notif => {
        popupComponent.createObject(server, { notif: notif })
    }
}
