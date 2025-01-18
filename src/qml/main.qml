import QtQuick 
import QtQuick.Window 
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtMultimedia 
import Style
import Qt5Compat.GraphicalEffects
import "Base"
import "Connectivity"
import "Media"
import "Music"
import "Settings"
import "Speed"
import "AI"

ApplicationWindow {
    id: root
    width: 800
    height: 480
    //flags: Qt.FramelessWindowHint // 移除窗口边框和标题栏
    visible: true

    property bool showFullItem: false

    // 添加 BlueWifi 组件
    BlueWifi {
        id: blueWifi
        visible: false
    }

    MusicPlayerWindow{
        id: musicPlayer
        visible: false
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

    Loader {
        id: notes
        source: "Notes/NotesWindow.qml"
        active: true
        visible: false
        anchors.fill: parent
    }

    Loader {
        id: aiAssistant
        source: "qrc:/src/qml/AI/AIAssistant.qml"
        active: true  // 确保组件被加载
        visible: false
        anchors.fill: parent  // 让 Loader 填充父组件
        //打印父控件名称

        onLoaded: {
            console.log("AI Assistant loaded")  // 添加日志
            console.log(this)
            console.log(parent)
        }
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
        onOpenAI: {
            console.log("Opening AI Assistant")
            if (aiAssistant.status === Loader.Ready) {
                aiAssistant.visible = true
                if (aiAssistant.item) {
                    aiAssistant.item.visible = true
                    aiAssistant.item.recording = true  // 直接开始录音
                    root.showFullItem = true
                }
            } else {
                console.log("AI Assistant not ready")
            }
        }
    }

    LaunchPadControl {  
        id: launcher
        y: 0
        x: (root.width - width ) / 2
    }
}
