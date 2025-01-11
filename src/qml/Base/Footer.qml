import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Style
import Qt5Compat.GraphicalEffects

Item {
    //
    height: 80
    width: parent.width
    signal openLauncher()
    // signal openBlueWifi() // 添加此信号

    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, 1000)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Style.black }
            GradientStop { position: 1.0; color: Style.black60 }
        }
    }


    Icon{
        id: leftControl
        icon.source: "qrc:/resources/app_icons/model-3.svg"
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 36
        onClicked: openLauncher()
    }

    RowLayout {
        id: middleLayout
        anchors.centerIn: parent
        spacing: 20

        Icon{
            icon.source: "qrc:/resources/app_icons/blue-wifi.svg"
            Layout.preferredWidth: 46   //不能使用width
            Layout.preferredHeight: 46
            onClicked: {
                root.showFullItem = !root.showFullItem 
                blueWifi.visible = true
            }
        }

        Icon{
            icon.source: "qrc:/resources/app_icons/wyy.svg"
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            onClicked: {
                root.showFullItem = !root.showFullItem
                musicPlayer.visible = !musicPlayer.visible
                console.log("open")
                console.log(blueWifi.visible)
                console.log(root.showFullItem)
            }
        }

        Icon{
            icon.source: "qrc:/resources/app_icons/dashcam.svg"
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            onClicked: {
                root.showFullItem = !root.showFullItem
                camera.visible = !camera.visible
                console.log("open")
                console.log(camera.visible)
                console.log(root.showFullItem)
            }
        }

        Icon{
            icon.source: "qrc:/resources/app_icons/video.svg"
            Layout.preferredWidth: 46
            Layout.preferredHeight: 46
            onClicked: {
                root.showFullItem = !root.showFullItem
                gallery.visible = !gallery.visible
                console.log("open")
                console.log(gallery.visible)
                console.log(root.showFullItem)
            }
        }

        Icon{
            icon.source: "qrc:/resources/app_icons/navi.svg"
            Layout.preferredWidth: 43
            Layout.preferredHeight: 43
            onClicked: {
                root.showFullItem = !root.showFullItem
                map.visible = !map.visible
                console.log("open")
                console.log(map.visible)
                console.log(root.showFullItem)
            }
        }

        Icon{
            icon.source: "qrc:/resources/app_icons/ride.svg"
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            onClicked: {
                root.showFullItem = !root.showFullItem
                speedView.visible = !speedView.visible
                console.log("open")
                console.log(speedView.visible)
                console.log(root.showFullItem)
            }
        }
    }

    Icon{
        id: rightControl
        icon.source: "qrc:/resources/app_icons/bot.svg"
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 36
        onClicked: openLauncher()
    }

}
