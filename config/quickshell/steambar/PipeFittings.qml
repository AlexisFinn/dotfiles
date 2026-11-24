import QtQuick

// The fittings of one visible length of pipe, laid out symmetrically over its width. A long
// length carries a valve between two flange joints and a thin bypass line that leaves the pipe
// at a riveted collar and joins it again at the next one; a short length only has a joint.
Canvas {
    id: root

    property real pipeRadius: 5.5

    height: Theme.consoleHeight

    onWidthChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d");
        const cy = height / 2;
        ctx.reset();
        if (width < 40)
            return;

        // A ring around the pipe, seen from the side.
        function ring(x, ringWidth, halfHeight, dark, mid, light) {
            ctx.fillStyle = Qt.rgba(0, 0, 0, 0.35);
            ctx.fillRect(x - ringWidth / 2 + 1, cy - halfHeight + 1.5, ringWidth, 2 * halfHeight);
            const shade = ctx.createLinearGradient(0, cy - halfHeight, 0, cy + halfHeight);
            shade.addColorStop(0, dark);
            shade.addColorStop(0.28, light);
            shade.addColorStop(0.55, mid);
            shade.addColorStop(1, dark);
            ctx.fillStyle = shade;
            ctx.fillRect(x - ringWidth / 2, cy - halfHeight, ringWidth, 2 * halfHeight);
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.6);
            ctx.lineWidth = 1;
            ctx.strokeRect(x - ringWidth / 2 + 0.5, cy - halfHeight + 0.5, ringWidth - 1, 2 * halfHeight - 1);
        }

        function dot(x, y, radius, color) {
            ctx.beginPath();
            ctx.arc(x, y, radius, 0, 2 * Math.PI);
            ctx.fillStyle = color;
            ctx.fill();
        }

        function collar(x) {
            ring(x, 8, pipeRadius + 1.5, Qt.darker(Theme.bronze, 1.8), Theme.bronze, Qt.lighter(Theme.bronze, 1.6));
            for (const offset of [-4, 0, 4])
                dot(x, cy + offset, 0.9, Theme.brassLight);
        }

        // Two bolted flanges face to face.
        function joint(x) {
            for (const side of [-2.5, 2.5]) {
                ring(x + side, 4, pipeRadius + 3.5, Theme.brassDark, Theme.brass, Theme.brassLight);
                for (const offset of [-pipeRadius - 1.6, pipeRadius + 1.6])
                    dot(x + side, cy + offset, 0.8, Theme.ironDark);
            }
        }

        function valve(x) {
            const radius = 8;
            const steel = Qt.lighter(Theme.iron, 2.6);
            ring(x, 7, pipeRadius + 2, Qt.darker(Theme.bronze, 1.8), Theme.bronze, Qt.lighter(Theme.bronze, 1.6));
            ctx.lineCap = "butt";
            for (const [dx, dy, color, lineWidth] of [[1, 1.5, Qt.rgba(0, 0, 0, 0.4), 2.6], [0, 0, steel, 2.2]]) {
                ctx.strokeStyle = color;
                ctx.lineWidth = lineWidth;
                ctx.beginPath();
                ctx.arc(x + dx, cy + dy, radius, 0, 2 * Math.PI);
                ctx.stroke();
                ctx.lineWidth = lineWidth - 0.8;
                for (let i = 0; i < 3; i++) {
                    const a = i * Math.PI / 3 + Math.PI / 6;
                    ctx.beginPath();
                    ctx.moveTo(x + dx - radius * Math.cos(a), cy + dy - radius * Math.sin(a));
                    ctx.lineTo(x + dx + radius * Math.cos(a), cy + dy + radius * Math.sin(a));
                    ctx.stroke();
                }
            }
            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.25);
            ctx.lineWidth = 0.8;
            ctx.beginPath();
            ctx.arc(x, cy, radius + 0.5, Math.PI * 1.1, Math.PI * 1.6);
            ctx.stroke();
            dot(x, cy, 2.6, Theme.brassDark);
            dot(x, cy, 1.8, Theme.brass);
            dot(x - 0.5, cy - 0.5, 0.8, Theme.brassLight);
        }

        // A thin line running above the pipe between two collars.
        function bypass(from, to) {
            const y = cy - pipeRadius - 6;
            const bend = 3.5;
            function trace() {
                ctx.beginPath();
                ctx.moveTo(from, cy - pipeRadius);
                ctx.lineTo(from, y + bend);
                ctx.quadraticCurveTo(from, y, from + bend, y);
                ctx.lineTo(to - bend, y);
                ctx.quadraticCurveTo(to, y, to, y + bend);
                ctx.lineTo(to, cy - pipeRadius);
            }
            ctx.lineJoin = "round";
            for (const [dy, color, lineWidth] of [[1.5, Qt.rgba(0, 0, 0, 0.35), 3.4], [0, Theme.brassDark, 3.4], [0, Theme.brass, 2.2], [-0.5, Theme.brassLight, 0.8]]) {
                ctx.save();
                ctx.translate(0, dy);
                trace();
                ctx.strokeStyle = color;
                ctx.lineWidth = lineWidth;
                ctx.stroke();
                ctx.restore();
            }
            // Clips holding the line.
            for (const x of [from + (to - from) * 0.3, from + (to - from) * 0.7]) {
                ctx.fillStyle = Qt.lighter(Theme.iron, 2.2);
                ctx.fillRect(x - 1.5, y - 2.5, 3, 5);
                ctx.fillStyle = Qt.rgba(0, 0, 0, 0.5);
                ctx.fillRect(x + 1.5, y - 2.5, 0.8, 5);
            }
        }

        const middle = width / 2;
        if (width < 150) {
            joint(middle);
            return;
        }
        const first = Math.max(24, width * 0.14);
        const last = width - first;
        bypass(first, last);
        collar(first);
        collar(last);
        joint(middle - 24);
        joint(middle + 24);
        valve(middle);
    }
}
