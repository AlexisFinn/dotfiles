pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Metals are fixed, like those of the window frames; only the lit elements and the text follow
// the wallpaper palette.
Singleton {
    id: root

    readonly property var palette: {
        try {
            return JSON.parse(file.text());
        } catch (e) {
            return {};
        }
    }

    readonly property color background: palette.background ?? "#120a07"
    readonly property color foreground: palette.foreground ?? "#c3c1c1"
    readonly property color accent: palette.color6 ?? "#debf84"

    readonly property color brass: Qt.hsla(0.105, 0.33, 0.44, 1)
    readonly property color brassLight: Qt.hsla(0.11, 0.42, 0.66, 1)
    readonly property color brassDark: Qt.hsla(0.095, 0.35, 0.24, 1)
    readonly property color bronze: Qt.hsla(0.085, 0.30, 0.31, 1)
    readonly property color copper: Qt.hsla(0.055, 0.46, 0.47, 1)
    readonly property color copperLight: Qt.hsla(0.06, 0.55, 0.72, 1)
    readonly property color copperDark: Qt.hsla(0.05, 0.45, 0.2, 1)
    readonly property color iron: Qt.hsla(0.08, 0.10, 0.17, 1)
    readonly property color ironDark: Qt.hsla(0.08, 0.12, 0.07, 1)
    readonly property color cream: Qt.hsla(0.12, 0.3, 0.8, 1)

    // Glow of lamps, tubes and gauge liquid: the palette accent, pushed bright and saturated.
    readonly property color glow: Qt.hsla(Math.max(accent.hslHue - 0.025, 0), 0.95, 0.62, 1)
    readonly property color glowDeep: Qt.hsla(Math.max(accent.hslHue - 0.05, 0), 0.9, 0.48, 1)
    readonly property color alert: Qt.hsla(0.01, 0.7, 0.6, 1)

    readonly property string labelFont: "Latin Modern Roman Caps"
    readonly property string valueFont: "C059"
    readonly property string digitFont: "Comfortaa"

    readonly property var locale: Qt.locale("fr_FR")

    readonly property int barHeight: 48
    readonly property int consoleHeight: 31

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.cache/hypr-theme/colors.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }
}
