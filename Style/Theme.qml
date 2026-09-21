pragma Singleton
// qmllint disable
import QtQuick
// qmllint enable

QtObject {
    // Base
    readonly property color background: "#011627"
    readonly property color foreground: "#bdc1c6"
    readonly property color bold: "#eeeeee"
    readonly property color cursor: "#9ca1aa"
    readonly property color cursorText: "#080808"
    readonly property color selection: "#b2ceee"
    readonly property color selectionText: "#080808"

    // Superfici (non nella palette terminale ufficiale, derivate per UI a livelli)
    readonly property color surface: "#092236"
    readonly property color elevated: "#1d3b53"

    // Colori "normal" (0-7)
    readonly property color black: "#1d3b53"
    readonly property color red: "#fc514e"
    readonly property color green: "#a1cd5e"
    readonly property color yellow: "#e3d18a"
    readonly property color blue: "#82aaff"
    readonly property color purple: "#c792ea"
    readonly property color cyan: "#7fdbca"
    readonly property color white: "#a1aab8"

    // Colori "bright" (8-15)
    readonly property color brightBlack: "#7c8f8f"
    readonly property color brightRed: "#ff5874"
    readonly property color brightGreen: "#21c7a8"
    readonly property color brightYellow: "#ecc48d"
    readonly property color brightBlue: "#82aaff"
    readonly property color brightPurple: "#ae81ff"
    readonly property color brightCyan: "#7fdbca"
    readonly property color brightWhite: "#d6deeb"

    // Alias semantici, comodi da usare nei moduli invece dei nomi colore grezzi
    readonly property color accent: blue
    readonly property color success: green
    readonly property color warning: yellow
    readonly property color danger: red
    readonly property color textMuted: white
}
