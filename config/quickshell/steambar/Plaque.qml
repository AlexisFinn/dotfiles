import QtQuick

// The engraved nameplate of one workspace, with its indicator lamp.
// `shown`: displayed on this screen. `lit`: displayed on any screen. `focused`: has the focus.
Item {
    id: root

    property string label
    property bool shown: false
    property bool lit: false
    property bool focused: false
    property bool occupied: false
    property bool urgent: false

    implicitWidth: content.implicitWidth + 14
    implicitHeight: 21

    Rectangle {
        anchors.fill: parent
        radius: 3
        visible: root.shown || root.occupied
        border.width: 1
        border.color: root.shown ? Theme.brassDark : Qt.rgba(0, 0, 0, 0.5)
        gradient: Gradient {
            GradientStop { position: 0; color: root.shown ? Theme.brassLight : Qt.lighter(Theme.bronze, 1.15) }
            GradientStop { position: 0.5; color: root.shown ? Theme.brass : Theme.bronze }
            GradientStop { position: 1; color: root.shown ? Qt.darker(Theme.brass, 1.25) : Qt.darker(Theme.bronze, 1.5) }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 3
        visible: !root.shown && !root.occupied
        color: Qt.rgba(0, 0, 0, 0.25)
        border.width: 1
        border.color: Qt.rgba(Theme.brass.r, Theme.brass.g, Theme.brass.b, 0.35)
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 5

        Lamp {
            id: lamp
            // The capitals sit below the middle of their line box.
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 2
            tint: root.urgent ? Theme.alert : Theme.glow
            level: root.urgent ? pulse : root.focused ? 1 : root.lit ? 0.45 : 0

            property real pulse: 1
            SequentialAnimation on pulse {
                running: root.urgent
                loops: Animation.Infinite
                NumberAnimation { to: 0.25; duration: 700; easing.type: Easing.InOutSine }
                NumberAnimation { to: 1; duration: 700; easing.type: Easing.InOutSine }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            font.family: Theme.labelFont
            font.pixelSize: 14
            font.letterSpacing: 0.6
            font.bold: root.shown
            color: root.shown ? Theme.ironDark : root.occupied ? Theme.cream : Qt.rgba(Theme.cream.r, Theme.cream.g, Theme.cream.b, 0.5)
            style: root.shown ? Text.Raised : Text.Normal
            styleColor: Qt.rgba(1, 1, 1, 0.3)
        }
    }
}
