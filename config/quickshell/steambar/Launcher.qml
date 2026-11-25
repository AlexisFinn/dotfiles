import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

// The launcher, over the focused screen: the wallpaper's frame of brass pipes and gears, with the
// matches listed in its opening and the selected one on a polished brass nameplate.
//
// It lists the installed applications (`qs ipc … call launcher toggle`), or serves as a menu
// for a script (`… call launcher menu <request file>`): the request is a JSON file naming the
// rows and a FIFO, on which the answer is written as three lines: `ok` or `cancel`, the text,
// and the position of the chosen row in the request (-1 for typed text).
Scope {
    id: root

    property bool open: false
    property string query: ""
    property int selected: 0
    property var screen: null

    // What a menu request asked for; null while the launcher lists the applications.
    property var menu: null

    // How many times each application was launched from here, by desktop entry id.
    property var usage: ({})

    readonly property var rows: menu ? menuRows(menu) : applicationRows(DesktopEntries.applications.values, usage)
    readonly property var results: ranked(rows, query)
    readonly property bool hasList: !(menu?.promptOnly ?? false)

    readonly property int rowHeight: 44

    // Pale gold for what is written on the dark plate, near black for what is engraved in brass.
    readonly property color gilt: Qt.hsla(0.115, 0.6, 0.76, 1)
    readonly property color engraved: Qt.hsla(0.07, 0.5, 0.07, 1)
    readonly property string fieldFont: "Courier 10 Pitch"

    function folded(text) {
        return String(text ?? "").toLowerCase().normalize("NFD").replace(/[̀-ͯ]/g, "");
    }

    function applicationRows(entries, counts) {
        return entries.filter(entry => !entry.noDisplay).sort((a, b) => a.name.localeCompare(b.name)).map((entry, order) => ({
                    label: entry.name,
                    detail: entry.genericName || entry.comment,
                    more: folded([entry.genericName, entry.keywords, entry.id, entry.comment].join(" ")),
                    icon: entry.icon,
                    uses: counts[entry.id] ?? 0,
                    order,
                    entry
                }));
    }

    function menuRows(request) {
        return request.items.map((label, order) => ({
                    label,
                    detail: "",
                    more: "",
                    icon: "",
                    uses: 0,
                    order,
                    isActive: request.active.includes(order),
                    isUrgent: request.urgent.includes(order)
                }));
    }

    // How well a row answers the search: the start of its label first, then the start of one of
    // its words, the inside of its label, its description, and last its letters in order.
    function score(row, wanted) {
        const label = folded(row.label);
        if (label.startsWith(wanted))
            return 5;
        if (label.split(/[\s\-_.]+/).some(word => word.startsWith(wanted)))
            return 4;
        if (label.includes(wanted))
            return 3;
        if (row.more.includes(wanted))
            return 2;
        let matched = 0;
        for (const letter of label) {
            if (letter === wanted[matched])
                matched += 1;
        }
        return matched === wanted.length ? 1 : 0;
    }

    function ranked(candidates, text) {
        const wanted = folded(text).trim();
        const scored = candidates.map(row => ({
                    row,
                    score: wanted === "" ? 1 : score(row, wanted)
                })).filter(item => item.score > 0);
        scored.sort((a, b) => b.score - a.score || b.row.uses - a.row.uses || a.row.order - b.row.order);
        return scored.map(item => item.row);
    }

    function show(request) {
        answer("cancel", "");
        const focused = Hyprland.focusedMonitor?.name;
        screen = Quickshell.screens.find(candidate => candidate.name === focused) ?? Quickshell.screens[0];
        menu = request;
        query = "";
        selected = 0;
        open = true;
    }

    function dismiss() {
        answer("cancel", "");
        open = false;
    }

    // Writes the answer of the menu request in progress, once.
    function answer(status, text, position = -1) {
        if (!menu)
            return;
        reply.exec(["sh", "-c", 'printf "%s\\n%s\\n%s\\n" "$1" "$2" "$3" > "$4"', "sh", status, text, String(position), menu.reply]);
        menu = null;
    }

    function accept() {
        const row = results[selected];
        if (!menu) {
            if (!row)
                return;
            const counts = Object.assign({}, usage);
            counts[row.entry.id] = (counts[row.entry.id] ?? 0) + 1;
            usage = counts;
            usageFile.setText(JSON.stringify(counts));
            open = false;
            row.entry.execute();
        } else if (hasList && row) {
            answer("ok", row.label, row.order);
            open = false;
        } else if (!menu.noCustom || !hasList) {
            answer("ok", query);
            open = false;
        }
    }

    function move(step) {
        if (results.length > 0)
            selected = (selected + step + results.length) % results.length;
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            if (root.open)
                root.dismiss();
            else
                root.show(null);
        }

        function close(): void {
            root.dismiss();
        }

        function menu(requestFile: string): void {
            request.path = "";
            request.path = requestFile;
        }
    }

    FileView {
        id: request
        blockLoading: true
        printErrors: false
        onLoaded: {
            let asked;
            try {
                asked = JSON.parse(text());
            } catch (e) {
                return;
            }
            if (typeof asked.reply !== "string")
                return;
            root.show({
                items: asked.items ?? [],
                active: asked.active ?? [],
                urgent: asked.urgent ?? [],
                prompt: asked.prompt ?? "",
                message: asked.message ?? "",
                placeholder: asked.placeholder ?? "",
                promptOnly: asked.promptOnly ?? false,
                noCustom: asked.noCustom ?? false,
                reply: asked.reply
            });
        }
    }

    Process {
        id: reply
    }

    FileView {
        id: usageFile
        path: Quickshell.statePath("launcher-usage.json")
        printErrors: false
        onLoaded: {
            try {
                root.usage = JSON.parse(text());
            } catch (e) {
                root.usage = {};
            }
        }
    }

    PanelWindow {
        visible: root.open
        screen: root.screen ?? Quickshell.screens[0]
        color: Qt.rgba(0, 0, 0, 0.4)
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "steambar-launcher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        onVisibleChanged: {
            if (visible) {
                input.text = "";
                input.forceActiveFocus();
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.dismiss()
        }

        // The wallpaper's frame of pipes and gears, with the rows laid out in its opening.
        Item {
            id: console_
            width: 1084
            height: 692
            anchors.centerIn: parent
            scale: Math.min(1, (parent.width - 40) / width, (parent.height - 40) / height)

            // Clicks on the console do not reach the backdrop, which closes the launcher.
            MouseArea {
                anchors.fill: parent
            }

            // The picture is transparent beyond the frame's outline, gears included; it casts a shadow.
            Image {
                anchors.fill: parent
                source: Qt.resolvedUrl("assets/frame.webp")
                mipmap: true
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "black"
                    shadowOpacity: 0.75
                    shadowBlur: 0.7
                    shadowHorizontalOffset: 5
                    shadowVerticalOffset: 9
                    autoPaddingEnabled: true
                }
            }

            // The opening of the frame, clear of the gears that reach into its lower corners.
            Item {
                id: opening
                x: 262
                y: 166
                width: 548
                height: 392

                // What is asked, engraved between two rules, and how many rows match.
                Item {
                    id: header
                    width: parent.width
                    height: 22

                    Text {
                        id: title
                        anchors.centerIn: parent
                        text: root.menu ? root.menu.prompt : "Machines"
                        font.family: Theme.labelFont
                        font.pixelSize: 16
                        font.letterSpacing: 3
                        color: root.gilt
                        style: Text.Raised
                        styleColor: Qt.rgba(0, 0, 0, 0.8)
                    }

                    Repeater {
                        model: [0, title.x + title.width + 14]

                        Item {
                            required property real modelData
                            x: modelData
                            y: header.height / 2
                            width: title.x - 14
                            height: 2

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: Qt.rgba(0, 0, 0, 0.6)
                            }

                            Rectangle {
                                y: 1
                                width: parent.width
                                height: 1
                                color: Qt.rgba(root.gilt.r, root.gilt.g, root.gilt.b, 0.35)
                            }
                        }
                    }
                }

                // The search field: a slot cut in a worn brass bar.
                Item {
                    id: field
                    y: root.hasList ? header.height + 8 : (parent.height - height) / 2
                    width: parent.width
                    height: 44

                    Image {
                        anchors.fill: parent
                        source: Qt.resolvedUrl("assets/bar.jpg")
                        mipmap: true
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.width: 1
                        border.color: Qt.rgba(0, 0, 0, 0.75)
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 7
                        radius: 3
                        color: Qt.rgba(0.05, 0.03, 0.02, 0.92)
                        border.width: 1
                        border.color: Qt.rgba(0, 0, 0, 0.9)

                        Rectangle {
                            x: 1
                            y: parent.height - 1
                            width: parent.width - 2
                            height: 1
                            color: Qt.rgba(root.gilt.r, root.gilt.g, root.gilt.b, 0.4)
                        }
                    }

                    Text {
                        id: count
                        anchors.right: parent.right
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        visible: root.hasList
                        text: root.results.length + " / " + root.rows.length
                        font.family: Theme.valueFont
                        font.pixelSize: 12
                        color: root.gilt
                        opacity: 0.6
                    }

                    TextInput {
                        id: input
                        x: 18
                        width: parent.width - 36 - (count.visible ? count.width + 12 : 0)
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                        font.family: root.fieldFont
                        font.pixelSize: 18
                        font.letterSpacing: 1.2
                        color: Theme.glow
                        selectionColor: Theme.bronze
                        selectedTextColor: Theme.cream
                        cursorDelegate: Rectangle {
                            width: 2
                            color: Theme.glow
                        }

                        onTextChanged: {
                            root.query = text;
                            root.selected = 0;
                        }

                        Keys.onPressed: event => {
                            const control = event.modifiers & Qt.ControlModifier;
                            if (event.key === Qt.Key_Escape) {
                                root.dismiss();
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                root.accept();
                            } else if (event.key === Qt.Key_Down || event.key === Qt.Key_Tab || (control && event.key === Qt.Key_N)) {
                                root.move(1);
                            } else if (event.key === Qt.Key_Up || event.key === Qt.Key_Backtab || (control && event.key === Qt.Key_P)) {
                                root.move(-1);
                            } else {
                                return;
                            }
                            event.accepted = true;
                        }
                    }

                    Text {
                        x: input.x + 8
                        width: input.width - 8
                        anchors.verticalCenter: parent.verticalCenter
                        visible: input.text === ""
                        elide: Text.ElideRight
                        text: root.menu ? root.menu.placeholder : "Quelle machine ?"
                        font: input.font
                        color: root.gilt
                        opacity: 0.4
                    }
                }

                Text {
                    id: message
                    y: field.y + field.height + 8
                    width: parent.width
                    visible: text !== ""
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: root.menu?.message ?? ""
                    font.family: Theme.valueFont
                    font.pixelSize: 13
                    font.italic: true
                    color: root.gilt
                    style: Text.Raised
                    styleColor: Qt.rgba(0, 0, 0, 0.8)
                }

                ListView {
                    id: list
                    y: message.visible ? message.y + message.height + 6 : field.y + field.height + 8
                    width: parent.width
                    height: parent.height - y
                    visible: root.hasList
                    clip: true
                    model: root.results
                    currentIndex: root.selected
                    highlightMoveDuration: 0
                    boundsBehavior: Flickable.StopAtBounds

                    delegate: Item {
                        id: row
                        required property var modelData
                        required property int index
                        readonly property bool isSelected: index === root.selected
                        readonly property bool isUrgent: modelData.isUrgent ?? false
                        readonly property bool isActive: modelData.isActive ?? false
                        readonly property bool isMarked: isUrgent || isActive
                        readonly property real labelX: modelData.icon !== "" ? 72 : 52

                        width: list.width
                        height: root.rowHeight

                        // The selected row is a polished brass nameplate, screwed at both ends.
                        Item {
                            anchors.fill: parent
                            anchors.topMargin: 3
                            anchors.bottomMargin: 3
                            visible: row.isSelected

                            Rectangle {
                                x: 2
                                y: 3
                                width: parent.width
                                height: parent.height
                                radius: 4
                                color: "black"
                                opacity: 0.55
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 4
                                border.width: 1
                                border.color: Qt.rgba(0.1, 0.06, 0.02, 0.9)
                                gradient: Gradient {
                                    GradientStop { position: 0; color: Qt.hsla(0.118, 0.66, 0.68, 1) }
                                    GradientStop { position: 0.14; color: Qt.hsla(0.115, 0.52, 0.56, 1) }
                                    GradientStop { position: 0.6; color: Qt.hsla(0.11, 0.48, 0.45, 1) }
                                    GradientStop { position: 1; color: Qt.hsla(0.1, 0.5, 0.28, 1) }
                                }
                            }

                            // The wear of the frame's own brass, over the polish.
                            Image {
                                anchors.fill: parent
                                anchors.margins: 2
                                source: Qt.resolvedUrl("assets/bar.jpg")
                                mipmap: true
                                opacity: 0.2
                            }

                            Rectangle {
                                x: 4
                                y: 1.5
                                width: parent.width - 8
                                height: 1
                                color: Qt.rgba(1, 0.96, 0.8, 0.55)
                            }

                            Repeater {
                                model: [10, parent.width - 18]

                                Rectangle {
                                    required property real modelData
                                    x: modelData
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 8
                                    height: 8
                                    radius: 4
                                    border.width: 1
                                    border.color: Qt.rgba(0.1, 0.06, 0.02, 0.85)
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: Qt.hsla(0.118, 0.6, 0.72, 1) }
                                        GradientStop { position: 1; color: Qt.hsla(0.1, 0.5, 0.3, 1) }
                                    }

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 6
                                        height: 1
                                        rotation: modelData === 10 ? 35 : -20
                                        color: Qt.rgba(0.1, 0.06, 0.02, 0.8)
                                    }
                                }
                            }
                        }

                        // An engraved groove under the other rows.
                        Rectangle {
                            x: 8
                            y: parent.height - 1
                            width: parent.width - 16
                            height: 1
                            visible: !row.isSelected
                            color: Qt.rgba(0, 0, 0, 0.35)
                        }

                        // A menu lights the rows it marks: red for urgent, green for done.
                        Lamp {
                            x: 30
                            anchors.verticalCenter: parent.verticalCenter
                            visible: row.isMarked
                            tint: row.isUrgent ? Theme.alert : Theme.done
                            level: 1
                        }

                        IconImage {
                            x: 32
                            anchors.verticalCenter: parent.verticalCenter
                            visible: row.modelData.icon !== ""
                            implicitSize: 26
                            source: visible ? Quickshell.iconPath(row.modelData.icon, "application-x-executable") : ""
                        }

                        Text {
                            id: name
                            x: row.labelX
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.min(implicitWidth, (parent.width - row.labelX - 30) * (row.modelData.detail === "" ? 1 : 0.6))
                            elide: Text.ElideRight
                            text: row.modelData.label
                            font.family: Theme.labelFont
                            font.pixelSize: 18
                            font.letterSpacing: 0.6
                            font.bold: row.isSelected
                            color: row.isSelected ? root.engraved : root.gilt
                            style: Text.Raised
                            styleColor: row.isSelected ? Qt.rgba(1, 0.95, 0.75, 0.35) : Qt.rgba(0, 0, 0, 0.8)
                        }

                        Text {
                            anchors.left: name.right
                            anchors.leftMargin: 14
                            anchors.right: parent.right
                            anchors.rightMargin: 30
                            anchors.baseline: name.baseline
                            horizontalAlignment: Text.AlignRight
                            elide: Text.ElideRight
                            text: row.modelData.detail
                            font.family: Theme.valueFont
                            font.pixelSize: 13
                            font.italic: true
                            color: row.isSelected ? root.engraved : root.gilt
                            opacity: row.isSelected ? 0.85 : 0.6
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.selected = row.index;
                                root.accept();
                            }
                        }
                    }
                }
            }

            // The keys, engraved on the worn bar under the opening.
            Text {
                x: 404
                y: 580
                width: 330
                height: 30
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: (root.hasList ? "Entrée  choisir   ·   Tab  suivant" : "Entrée  valider") + "   ·   Échap  fermer"
                font.family: Theme.labelFont
                font.pixelSize: 13
                font.letterSpacing: 0.6
                font.bold: true
                color: root.engraved
                style: Text.Raised
                styleColor: Qt.rgba(1, 0.95, 0.75, 0.3)
            }
        }
    }
}
