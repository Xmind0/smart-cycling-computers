import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Base"

Item {
    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent
        color: "black"
        radius: 10
    }

    ItemHeader {
        id: backItem
    }

    Rectangle {
        anchors {
            top: backItem.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: "black"

        GridView {
            id: gridView
            anchors.fill: parent
            anchors.margins: 10
            cellWidth: width / 3
            cellHeight: cellWidth
            model: ListModel {
                // 测试数据
                ListElement { source: "qrc://test1.jpg" }
                ListElement { source: "qrc:/images/test2.jpg" }
                ListElement { source: "qrc:/images/test3.jpg" }
            }
            delegate: Rectangle {
                width: gridView.cellWidth - 10
                height: gridView.cellHeight - 10
                color: "#2a2a2a"
                radius: 10

                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: model.source
                    fillMode: Image.PreserveAspectCrop
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("查看图片:", model.source)
                    }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: "暂无照片"
            color: "#ffffff"
            font.pixelSize: 20
            visible: gridView.count === 0
        }
    }
}
