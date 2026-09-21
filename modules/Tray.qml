pragma ComponentBehavior: Bound
import Quickshell.Services.SystemTray
// qmllint disable
import QtQuick
// qmllint enable
import QtQuick.Layouts
import Quickshell

import qs.Style

Rectangle {
    id: root
    required property var panelWindow
    color: Theme.surface
    implicitWidth: row.implicitWidth + 12
    implicitHeight: row.implicitHeight + 8
    radius: 4

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            id: repeater
            model: SystemTray.items

            delegate: Item {
                id: trayItem
                required property SystemTrayItem modelData
                width: 20
                height: 20
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.fill: parent
                    source: trayItem.modelData.icon
                    fillMode: Image.PreserveAspectFit
                }

                QsMenuAnchor {
                    id: trayMenu
                    anchor.window: root.panelWindow
                    anchor.item: trayItem
                    // qmllint disable
                    anchor.edges: Edges.Bottom
                    menu: trayItem.modelData.menu
                    // qmllint enable
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                    onClicked: mouse => {
                        let globalPos = mapToGlobal(mouse.x, mouse.y);
                        if (mouse.button === Qt.LeftButton) {
                            trayItem.modelData.activate(globalPos.x, globalPos.y);
                        } else if (mouse.button === Qt.RightButton) {
                            if (trayItem.modelData.hasMenu) {
                                trayMenu.open();
                                // trayItem.display(panel, mouse.x, mouse.y)
                            } else {
                                trayItem.modelData.secondaryActivate(globalPos.x, globalPos.y);
                            }
                        }
                    }

                    onWheel: wheel => trayItem.modelData.scroll(wheel.angleDelta.y, false)
                }
            }
        }
    }
}
