pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real cpu: 0
    property real memUsed: 0
    property real memTotal: 1
    property real diskAvailable: 0
    property real diskTotal: 1

    readonly property real memFraction: memUsed / memTotal
    readonly property real diskFraction: 1 - diskAvailable / diskTotal

    property real lastIdle: 0
    property real lastTotal: 0

    function readCpu() {
        const fields = stat.text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
        const idle = fields[3] + fields[4];
        const total = fields.reduce((sum, value) => sum + value, 0);
        if (lastTotal > 0 && total > lastTotal)
            cpu = 1 - (idle - lastIdle) / (total - lastTotal);
        lastIdle = idle;
        lastTotal = total;
    }

    function readMemory() {
        const text = meminfo.text();
        const kib = name => Number((text.match(new RegExp(name + ":\\s+(\\d+)")) ?? [0, 0])[1]);
        memTotal = Math.max(kib("MemTotal"), 1) * 1024;
        memUsed = memTotal - kib("MemAvailable") * 1024;
    }

    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: root.readCpu()
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: root.readMemory()
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            stat.reload();
            meminfo.reload();
        }
    }

    Process {
        id: df
        command: ["df", "-B1", "--output=size,avail", "/"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const fields = text.trim().split("\n").pop().trim().split(/\s+/).map(Number);
                if (fields.length === 2 && fields[0] > 0) {
                    root.diskTotal = fields[0];
                    root.diskAvailable = fields[1];
                }
            }
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: df.running = true
    }
}
