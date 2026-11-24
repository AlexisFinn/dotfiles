import QtQuick

// A steam pressure gauge with its name and reading engraved beside it: screwed porthole bezel,
// yellowed paper face, blued steel hand with a ring counterweight. The hand sweeps two thirds of
// a turn for `fraction` going from 0 to 1; the end of the scale from `alertAbove` is underlined.
Row {
    id: root

    property string label
    property string value
    property real fraction: 0
    property real alertAbove: 0.85
    property int diameter: 44

    readonly property real sweepStart: 150
    readonly property real sweep: 240

    readonly property color paper: Qt.hsla(0.115, 0.5, 0.8, 1)
    readonly property color paperEdge: Qt.hsla(0.09, 0.42, 0.5, 1)
    readonly property color ink: Qt.hsla(0.06, 0.45, 0.16, 1)
    readonly property color bluedSteel: Qt.hsla(0.6, 0.35, 0.2, 1)

    spacing: 6

    Item {
        anchors.verticalCenter: parent.verticalCenter
        width: root.diameter
        height: root.diameter

        Rectangle {
            x: 1
            y: 2
            width: parent.width
            height: parent.height
            radius: width / 2
            color: "black"
            opacity: 0.4
        }

        Canvas {
            id: face
            anchors.fill: parent

            property real alertAbove: root.alertAbove
            onAlertAboveChanged: requestPaint()

            onPaint: {
                const ctx = getContext("2d");
                const centre = width / 2;
                const outer = centre - 0.5;
                const glass = outer - 5.5;
                const scale = glass - 3.2;
                const angle = fraction => (root.sweepStart + root.sweep * fraction) * Math.PI / 180;
                const circle = (radius, x = 0, y = 0) => {
                    ctx.beginPath();
                    ctx.arc(x, y, radius, 0, 2 * Math.PI);
                };
                ctx.reset();
                ctx.translate(centre, centre);

                // Bezel: a domed brass ring held by six screws.
                const metal = ctx.createLinearGradient(-outer, -outer, outer, outer);
                metal.addColorStop(0, Theme.brassLight);
                metal.addColorStop(0.45, Theme.brass);
                metal.addColorStop(1, Theme.brassDark);
                circle(outer);
                ctx.fillStyle = metal;
                ctx.fill();
                ctx.lineWidth = 1;
                ctx.strokeStyle = Theme.ironDark;
                ctx.stroke();
                circle(outer - 1.4);
                ctx.lineWidth = 0.7;
                ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.3);
                ctx.stroke();
                for (let i = 0; i < 6; i++) {
                    const a = i * Math.PI / 3 + Math.PI / 6;
                    const x = (outer - 2.9) * Math.cos(a);
                    const y = (outer - 2.9) * Math.sin(a);
                    circle(1.3, x, y);
                    ctx.fillStyle = Theme.brassDark;
                    ctx.fill();
                    circle(0.6, x - 0.3, y - 0.3);
                    ctx.fillStyle = Theme.brassLight;
                    ctx.fill();
                }

                // Paper, darker and stained towards the rim.
                const sheet = ctx.createRadialGradient(-2, -3, 1, 0, 0, glass);
                sheet.addColorStop(0, Qt.lighter(root.paper, 1.08));
                sheet.addColorStop(0.6, root.paper);
                sheet.addColorStop(1, root.paperEdge);
                circle(glass);
                ctx.fillStyle = sheet;
                ctx.fill();
                ctx.lineWidth = 1.2;
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.7);
                ctx.stroke();

                // Scale: an inked arc with ticks hanging inside, the alert range doubled outside.
                ctx.strokeStyle = root.ink;
                ctx.lineWidth = 0.8;
                ctx.beginPath();
                ctx.arc(0, 0, scale, angle(0), angle(1));
                ctx.stroke();
                for (let i = 0; i <= 12; i++) {
                    const major = i % 3 === 0;
                    const a = angle(i / 12);
                    const inner = scale - (major ? 3.6 : 2);
                    ctx.lineWidth = major ? 1.3 : 0.7;
                    ctx.beginPath();
                    ctx.moveTo(scale * Math.cos(a), scale * Math.sin(a));
                    ctx.lineTo(inner * Math.cos(a), inner * Math.sin(a));
                    ctx.stroke();
                }
                ctx.beginPath();
                ctx.arc(0, 0, scale + 1.7, angle(alertAbove), angle(1));
                ctx.lineWidth = 1.5;
                ctx.strokeStyle = Qt.hsla(0.01, 0.6, 0.33, 1);
                ctx.stroke();

                // Maker's plate under the pivot.
                const plateWidth = 11, plateHeight = 4, plateY = glass * 0.5;
                ctx.fillStyle = Theme.brass;
                ctx.fillRect(-plateWidth / 2, plateY, plateWidth, plateHeight);
                ctx.lineWidth = 0.6;
                ctx.strokeStyle = root.ink;
                ctx.strokeRect(-plateWidth / 2, plateY, plateWidth, plateHeight);
                ctx.beginPath();
                ctx.moveTo(-plateWidth / 2 + 2, plateY + plateHeight / 2);
                ctx.lineTo(plateWidth / 2 - 2, plateY + plateHeight / 2);
                ctx.stroke();
            }
        }

        Canvas {
            id: hand
            anchors.fill: parent
            rotation: root.sweepStart + root.sweep * Math.min(Math.max(root.fraction, 0), 1)
            Behavior on rotation {
                NumberAnimation { duration: 900; easing.type: Easing.OutBack }
            }

            onPaint: {
                const ctx = getContext("2d");
                const centre = width / 2;
                const reach = centre - 8.5;
                ctx.reset();
                ctx.translate(centre, centre);
                for (const [dx, dy, color] of [[0.6, 1, Qt.rgba(0, 0, 0, 0.35)], [0, 0, root.bluedSteel]]) {
                    ctx.save();
                    ctx.translate(dx, dy);
                    ctx.fillStyle = color;
                    ctx.strokeStyle = color;
                    ctx.beginPath();
                    ctx.moveTo(reach, 0);
                    ctx.lineTo(0, -1.5);
                    ctx.lineTo(-3.5, -0.7);
                    ctx.lineTo(-3.5, 0.7);
                    ctx.lineTo(0, 1.5);
                    ctx.closePath();
                    ctx.fill();
                    ctx.lineWidth = 1.1;
                    ctx.beginPath();
                    ctx.arc(-5.6, 0, 2.1, 0, 2 * Math.PI);
                    ctx.stroke();
                    ctx.restore();
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 6
            height: 6
            radius: 3
            border.width: 1
            border.color: Theme.ironDark
            gradient: Gradient {
                GradientStop { position: 0; color: Theme.brassLight }
                GradientStop { position: 1; color: Theme.brassDark }
            }
        }

        // Reflection on the domed glass.
        Rectangle {
            x: parent.width * 0.27
            y: parent.height * 0.2
            width: parent.width * 0.26
            height: parent.height * 0.09
            radius: height / 2
            rotation: -30
            color: "white"
            opacity: 0.28
        }
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -1
        spacing: -4

        Text {
            text: root.label
            font.family: Theme.labelFont
            font.pixelSize: 12
            font.letterSpacing: 0.6
            color: Theme.brassLight
        }

        Text {
            text: root.value
            font.family: Theme.valueFont
            font.pixelSize: 13
            color: root.fraction >= root.alertAbove ? Theme.alert : Theme.cream
        }
    }
}
