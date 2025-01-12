import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
// import Qt.labs.settings 1.1
// import Qt.labs.platform 1.0
import QtQml 2.12
import Style
import QtCore  //Settings







//Rectangle
//RowLayout(item MusicTextButton MusicTextButton)
//MusicListView

ColumnLayout{

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("历史播放")
            font.family: Style.fontFamily
            font.pointSize: 25
            color: "white"
        }
    }

    RowLayout{
        height: 80
        Item{
            width: 5
        }

        MusicTextButton{
            btnText: "刷新记录"
            btnHeight: 45
            btnWidth: 90
            onClicked: getHistory()
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 45
            btnWidth: 90
            onClicked: clearHistory()
        }

    }

    MusicListView{
        id:historyListView
        onDeleteItem: deleteHistory(index)
    }

    Component.onCompleted: {
        getHistory()
    }

    Settings {
        id: historySettings
        location: StandardPaths.standardLocations(StandardPaths.AppConfigLocation)[0] + "/musicplayer.conf"
        category: "History"
        property var history: []
    }

    function getHistory() {
        historyListView.musicList = historySettings.history
    }

    function clearHistory() {
        historySettings.history = []
        getHistory()
    }

    function deleteHistory(index) {
        var list = historySettings.history
        if(list.length < index+1) return
        list.splice(index, 1)
        historySettings.history = list
        getHistory()
    }

}
