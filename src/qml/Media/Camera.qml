import QtQuick
import QtMultimedia
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

        MediaDevices {
            id: mediaDevices
        }

        Item {
            id: camera
            property bool active: true
            property QtObject imageCapture: QtObject {
                function capture() {
                    console.log("拍照")
                }
            }
            property QtObject videoRecorder: QtObject {
                property int recorderState: 0 // 0表示停止,1表示录制
                function stop() {
                    recorderState = 0
                    console.log("停止录制")
                }
                function record() {
                    recorderState = 1
                }
            }
        }

        Rectangle {
            id: videoOutput
            anchors {
                fill: parent
                margins: 20 // 添加边距
            }
            color: "#2a2a2a" // 稍微浅一点的灰色
            radius: 15 // 圆角

            Text {
                anchors.centerIn: parent
                text: "摄像头预览区域"
                color: "#ffffff"
                font {
                    pixelSize: 24
                    family: "Microsoft YaHei" // 使用微软雅黑字体
                }
                opacity: 0.8
            }

            // 添加边框效果
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                radius: parent.radius
                border.width: 2
                border.color: "#ffffff"
            }
        }

        // 图库按钮
        Button {
            width: 50
            height: 50
            anchors {
                left: parent.left
                bottom: parent.bottom
                leftMargin: 30
                bottomMargin: 30
            }
            background: Rectangle {
                color: parent.pressed ? "#404040" : "#333333"
                border.color: "#ffffff"
                border.width: 2
                radius: width/2
                
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/resources/app_icons/gallery.svg"
                    width: 25
                    height: 25
                    opacity: 0.9
                }
            }
            onClicked: {
                console.log("打开图库")
            }
        }

        RowLayout {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 30
            }
            spacing: 40

            // 拍照按钮
            Button {
                width: 70
                height: 70
                text: "拍照"
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    camera.imageCapture.capture()
                }
                background: Rectangle {
                    color: parent.pressed ? "#404040" : "#333333"
                    border.color: "#ffffff"
                    border.width: 2
                    radius: width/2 // 圆形按钮
                    
                    // 添加图标
                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/resources/app_icons/camera.svg" // 假设有这个图标
                        width: 30
                        height: 30
                        opacity: 0.9
                    }
                }
            }

            // 录制按钮
            Button {
                width: 70
                height: 70
                text: camera.videoRecorder.recorderState === 1 ? "停止" : "录制"
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    if (camera.videoRecorder.recorderState === 1) {
                        camera.videoRecorder.stop()
                    } else {
                        camera.videoRecorder.record()
                    }
                }
                background: Rectangle {
                    color: camera.videoRecorder.recorderState === 1 ? "#cc4444" : "#333333"
                    border.color: "#ffffff"
                    border.width: 2
                    radius: width/2 // 圆形按钮
                    
                    // 添加图标
                    Image {
                        anchors.centerIn: parent
                        // source: camera.videoRecorder.recorderState === 1 ?
                        //        "qrc:/resources/app_icons/stop.svg" :
                        //        "qrc:/resources/app_icons/record.svg" // 假设有这些图标
                        width: 30
                        height: 30
                        opacity: 0.9
                    }
                }
            }
        }

        // 摄像头切换按钮
        Button {
            width: 50
            height: 50
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: 30
                bottomMargin: 30
            }
            background: Rectangle {
                color: parent.pressed ? "#404040" : "#333333"
                border.color: "#ffffff"
                border.width: 2
                radius: width/2
                
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/resources/app_icons/switch_camera.svg"
                    width: 25
                    height: 25
                    opacity: 0.9
                }
            }
            onClicked: {
                console.log("切换摄像头")
            }
        }
    }
}
