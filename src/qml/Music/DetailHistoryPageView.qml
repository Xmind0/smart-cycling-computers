import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import QtQml 2.12
import Style

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

    function getHistory(){
        historyListView.musicList = historySettings.value("history",[])
    }

    function clearHistory(list=[]){
        historySettings.setValue("history",[])
        getHistory()
    }

    function deleteHistory(index){
        var list = historySettings.value("history",[])
        if(list.lenght<index+1)return
        list.splice(index,1)
         historySettings.setValue("history",list)
        getHistory()
    }

}
