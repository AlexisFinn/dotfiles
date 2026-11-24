import QtQuick
import QtQuick.Effects

// One glass tube showing a glowing character.
Item {
    id: root

    property string character: "0"

    implicitWidth: 17
    implicitHeight: 25

    Rectangle {
        anchors.fill: parent
        radius: 6
        border.width: 1
        border.color: Qt.rgba(Theme.brass.r, Theme.brass.g, Theme.brass.b, 0.55)
        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(0.13, 0.08, 0.05, 1) }
            GradientStop { position: 1; color: Qt.rgba(0.03, 0.02, 0.01, 1) }
        }
    }

    Text {
        id: digit
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 1
        text: root.character
        font.family: Theme.digitFont
        font.pixelSize: 17
        font.weight: Font.Medium
        color: Qt.lighter(Theme.glow, 1.15)
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.glowDeep
            shadowBlur: 0.9
            shadowOpacity: 1
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            autoPaddingEnabled: true
        }
    }

    Rectangle {
        x: 3
        y: 3
        width: 2
        height: parent.height - 9
        radius: 1
        color: "white"
        opacity: 0.13
    }
}
