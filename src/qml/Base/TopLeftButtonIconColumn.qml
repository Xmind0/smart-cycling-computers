import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ColumnLayout {
    spacing: 3
    Icon {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        icon.source: "qrc:/light-icons/Headlight2.svg"
        width: 18
        height: 18
    }
    Icon {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        icon.source: "qrc:/light-icons/Property 1=Default.svg"
        width: 18
        height: 18
    }
    Icon {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        icon.source: "qrc:/light-icons/Headlights.svg"
        width: 18
        height: 18
    }
    Icon {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        icon.source: "qrc:/light-icons/Seatbelt.svg"
        width: 18
        height: 18
    }
}
