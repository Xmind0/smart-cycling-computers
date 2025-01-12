import QtQuick 
import QtQuick.Window 
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtMultimedia 
import Style
import Qt5Compat.GraphicalEffects
import "./Base"
import "./Connectivity"
import "./Media"
import "./Music"
import "./Settings"
import "./Speed"

ApplicationWindow {
    id: root
    width: 800
    height: 480
    //flags: Qt.FramelessWindowHint // 移除窗口边框和标题栏
    visible: true

    property bool showFullItem: true

    // 添加 BlueWifi 组件
    BlueWifi {
        id: blueWifi
        visible: false
    }

    MusicPlayerWindow{
        id: musicPlayer
        visible: true
    }

    Camera{
        id: camera
        visible: false
    }

    Gallery{
        id: gallery
        visible: false
    }

    Map{
        id: map
        visible: false
    }

    SpeedView{
        id: speedView
        visible: false
    }

    background: Image {
        // icon :lock power   and  frunk open
        source: Style.getImageBasedOnTheme()
    }

    header: Header {
        id: headerLayout
        visible: !root.showFullItem 
    }

    footer: Footer {
        id: footerLayout
        visible: !root.showFullItem 
        onOpenLauncher: launcher.open()
    }

    LaunchPadControl {  
        id: launcher
        y: 0
        x: (root.width - width ) / 2
    }

}
