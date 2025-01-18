import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: control
    property string iconSource: ""

    contentItem: ColumnLayout {
        spacing: 5
        Image {
            id: icon
            source: control.iconSource
            Layout.alignment: Qt.AlignHCenter
            width: 24
            height: 24
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: control.text
            color: "white"
            font.pixelSize: 12
        }
    }

    background: Rectangle {
        implicitWidth: 80
        implicitHeight: 60
        color: control.pressed ? "#404040" : "transparent"
        radius: 6
    }
} 