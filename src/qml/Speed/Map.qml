import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
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
        height: 30
    }

    Rectangle {
        anchors {
            top: backItem.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: "black"
        radius: 15

        // 地图显示区域
        Rectangle {
            id: mapArea
            anchors {
                fill: parent
                margins: 10
            }
            color: "#2a2a2a"


            Text {
                anchors.centerIn: parent
                text: "地图显示区域,正在加载"
                color: "#ffffff"
                font.pixelSize: 20
            }
            WebEngineView {

                id: onlineMap
                visible: true
                backgroundColor: "transparent"
                anchors.fill: parent
                width: parent.width
                height: parent.height
                settings.javascriptEnabled : true
                settings.pluginsEnabled:true
                url:"qrc:/src/others/taskMap.html"  //加载地图的html文件
                Component.onCompleted: {
                    console.log("map.url: "+url)

                }
            }
        }

        // 导航控制面板
        Rectangle {
            id: navControl
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 20
            }
            width: 60
            height: 200
            color: "#333333"
            radius: 30

            Column {
                anchors.centerIn: parent
                spacing: 15

                // 放大按钮
                Button {
                    width: 40
                    height: 40
                    text: "+"
                    font.pixelSize: 20
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: parent.pressed ? "#404040" : "#333333"
                        border.color: "#ffffff"
                        border.width: 1
                        radius: width/2
                    }
                    onClicked: {
                        onlineMap.runJavaScript("zoomIn()", function(result) {
                            console.log("地图放大完成");
                        });
                    }
                }

                // 缩小按钮
                Button {
                    width: 40
                    height: 40
                    text: "-"
                    font.pixelSize: 20
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: parent.pressed ? "#404040" : "#333333"
                        border.color: "#ffffff"
                        border.width: 1
                        radius: width/2
                    }
                    onClicked: {
                        onlineMap.runJavaScript("zoomOut()", function(result) {
                            console.log("地图缩小完成");
                        });
                    }
                }

                // 定位按钮
                Button {
                    width: 40
                    height: 40
                    background: Rectangle {
                        color: parent.pressed ? "#404040" : "#333333"
                        border.color: "#ffffff"
                        border.width: 1
                        radius: width/2
                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/resources/app_icons/location.svg"
                            width: 20
                            height: 20
                        }
                    }
                    onClicked: {
                        onlineMap.runJavaScript("locateCurrentPosition()", function(result) {
                            console.log("正在定位当前位置");
                        });
                    }
                }
            }
        }

        // 路线规划按钮
        // Button {
        //     anchors {
        //         left: parent.left
        //         bottom: parent.bottom
        //         margins: 20
        //     }
        //     width: 120
        //     height: 50
        //     text: "路线规划"
        //     contentItem: Text {
        //         text: parent.text
        //         color: "white"
        //         horizontalAlignment: Text.AlignHCenter
        //         verticalAlignment: Text.AlignVCenter
        //     }
        //     background: Rectangle {
        //         color: parent.pressed ? "#404040" : "#333333"
        //         border.color: "#ffffff"
        //         border.width: 1
        //         radius: 25
        //     }
        //     onClicked: console.log("打开路线规划")
        // }
    }
}
