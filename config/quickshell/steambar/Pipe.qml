import QtQuick

// The bare copper steam pipe the consoles are mounted on.
Item {
    id: root

    Rectangle {
        y: 1.5
        width: parent.width
        height: parent.height
        color: "black"
        opacity: 0.3
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: Theme.copperDark }
            GradientStop { position: 0.22; color: Theme.copper }
            GradientStop { position: 0.36; color: Theme.copperLight }
            GradientStop { position: 0.55; color: Theme.copper }
            GradientStop { position: 1; color: Theme.copperDark }
        }
    }
}
