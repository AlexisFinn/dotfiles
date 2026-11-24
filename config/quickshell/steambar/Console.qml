import QtQuick

// A dark riveted plate with a brass bezel, bolted on the pipe by a flange on each open side.
Item {
    id: root

    default property alias content: row.data
    property int padding: 13
    property bool flangeLeft: true
    property bool flangeRight: true

    implicitWidth: row.implicitWidth + 2 * padding
    implicitHeight: Theme.consoleHeight

    Repeater {
        model: [root.flangeLeft ? -5 : NaN, root.flangeRight ? root.width - 1 : NaN]

        Rectangle {
            required property real modelData
            visible: !isNaN(modelData)
            x: visible ? modelData : 0
            y: (root.height - height) / 2
            width: 6
            height: 19
            radius: 1.5
            border.color: Theme.ironDark
            border.width: 1
            gradient: Gradient {
                GradientStop { position: 0; color: Theme.brassDark }
                GradientStop { position: 0.3; color: Theme.brassLight }
                GradientStop { position: 0.6; color: Theme.brass }
                GradientStop { position: 1; color: Theme.brassDark }
            }
        }
    }

    Rectangle {
        x: 1
        y: 2
        width: parent.width
        height: parent.height
        radius: 8
        color: "black"
        opacity: 0.35
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        gradient: Gradient {
            GradientStop { position: 0; color: Theme.brassLight }
            GradientStop { position: 0.45; color: Theme.brass }
            GradientStop { position: 1; color: Theme.brassDark }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1.5
        radius: 6.5
        border.color: Qt.rgba(0, 0, 0, 0.55)
        border.width: 1
        gradient: Gradient {
            GradientStop { position: 0; color: Qt.lighter(Theme.iron, 1.25) }
            GradientStop { position: 0.5; color: Theme.iron }
            GradientStop { position: 1; color: Theme.ironDark }
        }
    }

    Repeater {
        model: [[5, 5], [root.width - 5, 5], [5, root.height - 5], [root.width - 5, root.height - 5]]

        Rectangle {
            required property var modelData
            x: modelData[0] - 1.5
            y: modelData[1] - 1.5
            width: 3
            height: 3
            radius: 1.5
            gradient: Gradient {
                GradientStop { position: 0; color: Theme.brassLight }
                GradientStop { position: 1; color: Theme.brassDark }
            }
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        height: parent.height
        spacing: 9
    }
}
