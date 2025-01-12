//DetailFavoritePageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtCore
// import Qt.labs.settings 1.1  //settings 好像不支持
// import Qt.labs.platform 1.0
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

    Settings {
        id: favoriteSettings
        location: StandardPaths.standardLocations(StandardPaths.AppConfigLocation)[0] + "/musicplayer.conf"
        category: "Favorite" 
        property var favorite: []
    }

    function getFavorite() {
        try {
            // 确保我们有一个有效的初始值
            var savedData = favoriteSettings.favorite
            if (!savedData || savedData === "") {
                favoriteListView.musicList = []
                return
            }
            
            // 如果是字符串，尝试解析
            if (typeof savedData === 'string') {
                savedData = JSON.parse(savedData)
            }
            
            // 确保结果是数组
            if (!Array.isArray(savedData)) {
                favoriteListView.musicList = []
                return
            }
            
            favoriteListView.musicList = savedData
        } catch(e) {
            console.log("Error getting favorite:", e)
            favoriteListView.musicList = []
            // 重置为空数组
            favoriteSettings.setValue("favorite", "[]")
        }
    }

    function clearFavorite() {
        favoriteSettings.setValue("favorite", "[]")
        getFavorite()
    }

    function deleteFavorite(index) {
        try {
            var savedData = favoriteSettings.value("favorite", "[]")
            var list = JSON.parse(savedData)
            if (!Array.isArray(list)) {
                list = []
            }
            if(list.length < index+1) return
            list.splice(index, 1)
            favoriteSettings.setValue("favorite", JSON.stringify(list))
            getFavorite()
        } catch(e) {
            console.log("Error in deleteFavorite:", e)
            favoriteSettings.setValue("favorite", "[]")
            getFavorite()
        }
    }

}
