import QtQuick

// A jewel indicator in a brass ring. `level` goes from 0 (off) to 1 (fully lit).
Item {
    id: root

    property real level: 0
    property color tint: Theme.glow

    implicitWidth: 9
    implicitHeight: 9

    Rectangle {
        anchors.centerIn: parent
        width: 17
        height: 17
        radius: 8.5
        color: root.tint
        opacity: 0.1 * root.level
    }

    Rectangle {
        anchors.centerIn: parent
        width: 13
        height: 13
        radius: 6.5
        color: root.tint
        opacity: 0.2 * root.level
    }

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        gradient: Gradient {
            GradientStop { position: 0; color: Theme.brassLight }
            GradientStop { position: 1; color: Theme.brassDark }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1.5
        radius: width / 2
        color: Qt.tint(Theme.ironDark, Qt.rgba(root.tint.r, root.tint.g, root.tint.b, 0.15 + 0.85 * root.level))
    }

    Rectangle {
        x: 2.5
        y: 2.5
        width: 2
        height: 2
        radius: 1
        color: "white"
        opacity: 0.25 + 0.5 * root.level
    }
}
