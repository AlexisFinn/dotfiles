import QtQuick
import Quickshell

ShellRoot {
    id: root

    // STEAMBAR_PREVIEW=<screen name> shows a single bar, laid over the bottom of that screen.
    readonly property string previewScreen: Quickshell.env("STEAMBAR_PREVIEW") ?? ""

    Variants {
        model: Quickshell.screens.filter(s => root.previewScreen === "" || s.name === root.previewScreen)

        Bar {
            required property var modelData
            screen: modelData
            preview: root.previewScreen !== ""
        }
    }
}
