import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// Application icons in a recessed well. Left click activates, right click opens the menu.
Item {
    id: root

    required property var window

    visible: SystemTray.items.values.length > 0
    implicitWidth: icons.implicitWidth + 12
    implicitHeight: 23

    Rectangle {
        anchors.fill: parent
        radius: 4
        color: Qt.rgba(0, 0, 0, 0.45)
        border.width: 1
        border.color: Qt.rgba(0, 0, 0, 0.7)
    }

    Rectangle {
        x: 1
        y: parent.height - 1
        width: parent.width - 2
        height: 1
        color: Qt.rgba(1, 1, 1, 0.08)
    }

    Row {
        id: icons
        anchors.centerIn: parent
        spacing: 7

        Repeater {
            model: SystemTray.items

            IconImage {
                id: icon
                required property var modelData
                source: modelData.icon
                implicitSize: 16

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: event => {
                        if (event.button === Qt.LeftButton && !icon.modelData.onlyMenu) {
                            icon.modelData.activate();
                        } else if (icon.modelData.hasMenu) {
                            const at = icon.mapToItem(null, 0, icon.height + 6);
                            icon.modelData.display(root.window, at.x, at.y);
                        }
                    }
                }
            }
        }
    }
}
