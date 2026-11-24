import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: bar

    // Preview mode lays the bar over the bottom of the screen without reserving any space.
    property bool preview: false

    // Narrow screens keep only the workspaces, the clock and the tray.
    readonly property bool compact: width < 1500

    readonly property var workspaces: [...Hyprland.workspaces.values].filter(w => w.id > 0).sort((a, b) => a.id - b.id)

    anchors {
        top: !preview
        bottom: preview
        left: true
        right: true
    }
    implicitHeight: Theme.barHeight
    exclusiveZone: preview ? 0 : Theme.barHeight
    color: "transparent"
    WlrLayershell.namespace: "steambar"
    WlrLayershell.layer: preview ? WlrLayer.Overlay : WlrLayer.Top

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Pipe {
        x: 0
        width: parent.width
        height: 11
        anchors.verticalCenter: parent.verticalCenter
    }

    Repeater {
        model: [[left, middle], [middle, right]]

        PipeFittings {
            required property var modelData
            x: modelData[0].x + modelData[0].width + 5
            width: modelData[1].x - 5 - x
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Console {
        id: left
        x: 8
        anchors.verticalCenter: parent.verticalCenter
        flangeLeft: false

        Repeater {
            model: bar.workspaces

            Plaque {
                required property var modelData
                anchors.verticalCenter: parent.verticalCenter
                label: modelData.name
                shown: modelData.active && modelData.monitor?.name === bar.screen.name
                lit: modelData.active
                focused: modelData.focused
                occupied: modelData.toplevels.values.length > 0
                urgent: modelData.urgent
            }
        }
    }

    Console {
        id: middle
        // Centred on the screen, or in the space left between the two other consoles.
        x: bar.compact ? (left.x + left.width + right.x - width) / 2 : (parent.width - width) / 2
        anchors.verticalCenter: parent.verticalCenter

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Repeater {
                model: Qt.formatDateTime(clock.date, "HH:mm").split("")

                Nixie {
                    required property string modelData
                    character: modelData
                    implicitWidth: modelData === ":" ? 9 : 17
                }
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: date.implicitWidth + 14
            height: 21
            radius: 3
            border.width: 1
            border.color: Qt.rgba(0, 0, 0, 0.5)
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.lighter(Theme.bronze, 1.15) }
                GradientStop { position: 1; color: Qt.darker(Theme.bronze, 1.5) }
            }

            Text {
                id: date
                anchors.centerIn: parent
                text: Theme.locale.toString(clock.date, "ddd d MMM").replace(/\./g, "").replace(/(^|\s)\S/g, c => c.toUpperCase())
                font.family: Theme.labelFont
                font.pixelSize: 14
                font.letterSpacing: 0.6
                color: Theme.cream
            }
        }
    }

    Console {
        id: right
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        flangeRight: false

        Dial {
            anchors.verticalCenter: parent.verticalCenter
            visible: !bar.compact
            label: "Disque"
            fraction: Sys.diskFraction
            alertAbove: 0.9
            value: (Sys.diskAvailable / 1e9).toFixed(0) + " G"
        }

        Dial {
            anchors.verticalCenter: parent.verticalCenter
            visible: !bar.compact
            label: "Mém"
            fraction: Sys.memFraction
            value: (Sys.memUsed / 1073741824).toFixed(1) + " G"
        }

        Dial {
            anchors.verticalCenter: parent.verticalCenter
            visible: !bar.compact
            label: "Proc"
            fraction: Sys.cpu
            alertAbove: 0.9
            value: Math.round(Sys.cpu * 100) + " %"
        }


        Tray {
            anchors.verticalCenter: parent.verticalCenter
            window: bar
        }
    }
}
