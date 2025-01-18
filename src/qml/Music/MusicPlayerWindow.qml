// MusicPlayerWindow.qml
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Network 1.0
import QtMultimedia
import QtCore
import QtQml 2.12
import Style
import "../Base"


Item {

    width: parent.width
    height: parent.height

    // 添加常量属性
    readonly property int headerHeight: 20
    readonly property int layoutBottomHeight: 50

    Image {
        id: background
        anchors.fill: parent
        source: Style.getImageBasedOnTheme()
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#FF000000"  // 半透明黑色遮罩
    }

    ItemHeader {
        id: backItem
        width: parent.width
        height: headerHeight
    }

    // 修改主要内容区域的布局
    Item {
        anchors {
            top: backItem.bottom
            left: parent.left
            right: parent.right
            bottom: layoutBottomView.top
        }

        PageHomeView {
            id: pageHomeView
            anchors.fill: parent
            visible: true
        }

        PageDetailView {
            id: pageDetailView
            anchors.fill: parent
            visible: false
            onVisibleChanged: {
                if (visible) {
                    console.log("BlueWifi 组件变为可见")
                }
            }
        }
    }

    LayoutBottomView {
        id: layoutBottomView
        height: layoutBottomHeight
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    function initialize() {
        timer.start()
    }

    Component.onCompleted: {
        initialize()
        // fetchData() // 初始化时调用fetchData
    }

    // background: Background {
    //     id: appBackground
    // }

    // AppSystemTrayIcon {}

    HttpUtils {
        id: http
        onReplySignal: {
            // console.log("Received reply: ", reply);
            // 处理返回的数据，例如更新UI或存储数据
        }
    }

    Settings {
        id: settings
        location: StandardPaths.standardLocations(StandardPaths.AppConfigLocation)[0] + "/musicplayer.conf"
        category: "Player"
        property var currentPlayMode: 0
    }

    Settings {
        id: historySettings
        location: StandardPaths.standardLocations(StandardPaths.AppConfigLocation)[0] + "/musicplayer.conf"
        category: "History"
        property var history: []
    }


    Settings {
        id: favoriteSettings
        location: StandardPaths.standardLocations(StandardPaths.AppConfigLocation)[0] + "/musicplayer.conf"
        category: "Favorite"
        property var favorite: []
    }



    MusicNotification {
        id: notification
    }

    MusicLoading {
        id: loading
    }

    Timer {
        id: timer
        interval: 2000
        // onTriggered: notification.open()
    }
    AudioOutput {
        id: audioOutput
        volume: 1.0  // 设置音量
    }
    MediaPlayer {
        id: mediaPlayer
        audioOutput: AudioOutput {}

        onPositionChanged: function(position) {
            layoutBottomView.setSlider(0, duration, position);
        }

        onPlaybackStateChanged: {
            layoutBottomView.playingState = mediaPlayer.playbackState === MediaPlayer.PlayingState ? 1 : 0
            if (playbackState == MediaPlayer.StoppedState && layoutBottomView.playbackStateChangeCallbackEnabled) {
                layoutBottomView.playNext()
            }
        }

        onErrorChanged: {
            console.log("MediaPlayer error: ", errorString());
        }
    }

}
