//DetailFavoritePageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
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
            text: qsTr("我喜欢的")
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
            onClicked: getFavorite()
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 45
            btnWidth: 90
            onClicked: clearFavorite()
        }

    }

    MusicListView{
        id:favoriteListView
        favoritable: false
        onDeleteItem: deleteFavorite(index)
    }

    Component.onCompleted: {
        getFavorite()
    }

    function getFavorite(){
        // console.log(favoriteSettings)
        // favoriteListView.musicList = favoriteSettings.value("favorite",[])
        // console.log("this is"+favoriteListView.musicList)
    }

    function clearFavorite(){
        let favoriteList = ["Song1", "Song2", "Song3"]
        // favoriteSettings.setValue("favorite", favoriteList.toVariant())
        getFavorite()
    }

    function deleteFavorite(index){
        // var list = historySettings.value("favorite",[])
        if(list.lenght<index+1)return
        list.splice(index,1)
        // favoriteSettings.setValue("favorite",list)
        getFavorite()
    }

}
