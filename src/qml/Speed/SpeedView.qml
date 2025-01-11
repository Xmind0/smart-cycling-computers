import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Style
import "../Base"

Item {
    width: parent.width 
    height: parent.height

    // 主背景
    Rectangle {
        anchors.fill: parent
        color: "black"
        radius: 10
    }

    ItemHeader {
        id: backItem
    }

    // 速度显示区域
    ColumnLayout {
        anchors.top: backItem.bottom
        anchors.centerIn: parent
        spacing: 20

        // 当前速度
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "当前速度"
                color: "#808080"
                font.pixelSize: 24
                font.family: Style.fontFamily
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                
                Text {
                    id: speedText
                    text: "25" // 这里需要绑定实际速度数据
                    color: "white"
                    font.pixelSize: 72
                    font.family: Style.fontFamily
                    font.bold: true
                }

                Text {
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 10
                    text: "km/h"
                    color: "#808080"
                    font.pixelSize: 24
                    font.family: Style.fontFamily
                }
            }
        }

        // 其他骑行数据
        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            columns: 2
            columnSpacing: 50
            rowSpacing: 20

            // 平均速度
            ColumnLayout {
                spacing: 5
                Text {
                    text: "平均速度"
                    color: "#808080"
                    font.pixelSize: 16
                    font.family: Style.fontFamily
                }
                Text {
                    text: "20 km/h"  // 需要绑定实际数据
                    color: "white"
                    font.pixelSize: 24
                    font.family: Style.fontFamily
                }
            }

            // 最高速度
            ColumnLayout {
                spacing: 5
                Text {
                    text: "最高速度"
                    color: "#808080"
                    font.pixelSize: 16
                    font.family: Style.fontFamily
                }
                Text {
                    text: "35 km/h"  // 需要绑定实际数据
                    color: "white"
                    font.pixelSize: 24
                    font.family: Style.fontFamily
                }
            }

            // 骑行时间
            ColumnLayout {
                spacing: 5
                Text {
                    text: "骑行时间"
                    color: "#808080"
                    font.pixelSize: 16
                    font.family: Style.fontFamily
                }
                Text {
                    text: "01:30:25"  // 需要绑定实际数据
                    color: "white"
                    font.pixelSize: 24
                    font.family: Style.fontFamily
                }
            }

            // 骑行里程
            ColumnLayout {
                spacing: 5
                Text {
                    text: "骑行里程"
                    color: "#808080"
                    font.pixelSize: 16
                    font.family: Style.fontFamily
                }
                Text {
                    text: "25.8 km"  // 需要绑定实际数据
                    color: "white"
                    font.pixelSize: 24
                    font.family: Style.fontFamily
                }
            }
        }
    }
}
