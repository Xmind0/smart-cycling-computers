import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Style


// Rectangle
// RowLayout(TextField MusicIconButton)
// MusicListView
ColumnLayout{
    Layout.fillWidth: true
    Layout.fillHeight: true

    // 标题
    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("搜索音乐")
            font.family: Style.fontFamily
            font.pointSize: 25
            color: "white"
        }
    }

    //搜索框
    RowLayout{

        Layout.fillWidth: true
        Item{
            width:5
        }

        TextField{
            id:searchInput
            font.family: Style.fontFamily
            font.pointSize: 14
            selectByMouse: true   //能否用鼠标选择
            selectionColor: "#999999"  //设置选中文本的背景颜色为灰色
            placeholderText: qsTr("请输入搜索关键词")
            color: "#ffffffff" //设置文本字段中文本的颜色为黑色
            background: Rectangle{
                border.width: 1
                border.color: "#00000000" //设置边框的颜色为黑色。
                opacity: 0.5
                implicitHeight: 40
                implicitWidth: 400
            }
            focus: true
            Keys.onEnterPressed: doSearch()
            Keys.onReturnPressed: doSearch()
        }
        MusicIconButton{
            iconSource: "qrc:/resources/music_icons/search"
            toolTip: "搜索"
            onClicked: doSearch()
        }
    }

    //    Frame{
    //        id:musicListView
    //        Layout.fillWidth: true
    //        Layout.fillHeight: true
    //    }

    //搜索结果
    MusicListView{
        id:musicListView
        deleteable: false
        onLoadData: doSearch(offset,current)
        Layout.topMargin: 10
    }


    function doSearch(offset = 0, current = 0) {
        loading.open()
        var keywords = searchInput.text
        if(keywords.length < 1) return

        function onReply(requestId, reply) {
            if(requestId !== "search") return;
            loading.close()
            http.replySignal.disconnect(onReply)

            try {
                if(reply.length<1) {
                    return
                }
                var result = JSON.parse(reply).result
                musicListView.current = current
                musicListView.all = result.songCount
                musicListView.musicList = result.songs.map(item=>{
                    return {
                        id:item.id,
                        name:item.name,
                        artist:item.artists[0].name,
                        album:item.album.name,
                        cover:""
                    }
                })
            } catch(err) {
                notification.openError("请求搜索错误！")
            }
        }
        
        http.replySignal.connect(onReply)
        http.get("search?keywords="+keywords+"&offset="+offset+"&limit=60", "search")
    }
}
