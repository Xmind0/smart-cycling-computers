import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import QtCore
import QtQml 2.12
import Style




ColumnLayout{

    Settings {
        id: localSettings
        location: StandardPaths.standardLocations(StandardPaths.AppConfigLocation)[0] + "/musicplayer.conf"
        category: "LocalMusic"
        property var local: []
    }


    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("本地音乐")
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
            btnText: "添加本地音乐"
            btnHeight: 45
            btnWidth: 100
            onClicked: {
                fileDialog.open()
            }
        }
        MusicTextButton{
            btnText: "刷新记录"
            btnHeight: 45
            btnWidth: 90
            onClicked: getLocal()
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 45
            btnWidth: 90
            onClicked: saveLocal()
        }

    }

    MusicListView{
        id:localListView
        onDeleteItem: deleteLocal(index)
    }

    Component.onCompleted: {
        getLocal()
    }

    function getLocal(){
        localListView.musicList = localSettings.local
        return localSettings.local
    }

    function saveLocal(list=[]){
        localSettings.local = list
        localListView.musicList = list
    }

    function deleteLocal(index){
        var list = localSettings.local
        if(list.length < index+1) return
        list.splice(index, 1)
        localSettings.local = list
        localListView.musicList = list
    }



    FileDialog{
        id:fileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["MP3 Music Files(*.mp3)","FLAC MUsic Files(*.flac)"]
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        acceptLabel: "确定"
        rejectLabel: "取消"

        onAccepted: {
            var list = localSettings.local || []
            for(var index in files){
                var path = files[index]
                let filePath = String(path)
                let rawFileName = filePath.split('/').pop()
                var fileNameArr = rawFileName.split(".")
                fileNameArr.pop()

                var fileName = fileNameArr.join(".")
                var nameArr = fileName.split("-")
                var name = "未知歌曲"
                var artist = "未知歌手"

                if(nameArr.length > 1) {
                    artist = nameArr[0].trim()
                    nameArr.shift()
                    name = nameArr.join("-").trim()
                }

                if(list.filter(item=>item.id === path).length < 1) {
                    list.push({
                        id: path,
                        name: name,
                        artist: artist,
                        url: path,
                        album: "本地音乐",
                        type: "1"
                    })
                }
            }
            saveLocal(list)
        }
    }
}
