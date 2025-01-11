import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Style

RowLayout {
    spacing: 12
    property int temp: 72
    anchors.right: parent.right
    property bool airbagOn: false
    Text {
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        text: "12:00"
        font.family: "Inter"
        font.pixelSize: 23
        font.bold: Font.DemiBold
        color: Style.black20
    }

    Text {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        text: "%0℃".arg(temp)
        font.family: "Inter"
        font.pixelSize: 23
        font.bold: Font.DemiBold
        color: Style.black20
    }

    // Control {
    //     Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    //     implicitHeight: 38
    //     id: controlID
    //     background: Rectangle {
    //         color: Style.black20
    //         radius: 7
    //     }
    //     contentItem: RowLayout {
    //         spacing: 10
    //         anchors.centerIn: parent
    //         Image {
    //             Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    //             Layout.leftMargin: 10
    //             source: "qrc:/resources/top_header_icons/airbag_.svg"
    //         }
    //         Text {
    //             Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    //             Layout.rightMargin: 10
    //             text: airbagOn ? "PASSENGER\nAIRBAG ON" : "PASSENGER\nAIRBAG OFF"
    //             font.family: Style.fontFamily
    //             font.bold: Font.Bold
    //             font.pixelSize: 12
    //             color: Style.white
    //         }
    //     }
    // }

    // Component.onCompleted: {
    //     console.log("Control位置信息:")
    //     console.log("x:", controlID.x)
    //     console.log("y:", controlID.y)
    //     console.log("宽度:", controlID.width)
    //     console.log("高度:", controlID.height)
    // }
}
