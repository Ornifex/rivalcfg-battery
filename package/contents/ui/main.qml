import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    Layout.minimumWidth: 100
    Layout.minimumHeight: 40

    Plasma5Support.DataSource {
        id: rivalcfgSource
        engine: "executable"
        connectedSources: ["rivalcfg --battery-level"]
        interval: 600000 
        
        onNewData: (sourceName, data) => {
            var output = data["stdout"].trim();
            if (output) {
                // Regex matches digits (\d+)
                var match = output.match(/\d+/);
                if (match) {
                    batteryLabel.text = match[0];
                } else {
                    batteryLabel.text = output;
                }
            } else {
                batteryLabel.text = "Off";
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        
        PlasmaComponents.Label {
            id: batteryLabel
            text: "..."
            font.pointSize: 12
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true

            color: {
                var pct = parseInt(text);
                if (!isNaN(pct) && pct <= 10) {
                    return "#ED1515";
                } else {
                    return PlasmaComponents.Label.color; 
                }
            }
        }
    }
}
