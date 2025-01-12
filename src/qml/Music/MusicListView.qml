//MusicListView.qml
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtQml 2.12
import QtQuick.Shapes 1.12
import Style


//
Frame{
    property var musicList: []
    property int all: 0
    property int pageSize: 60
    property int current: 0

    property bool deleteable: true
    property bool favoritable: true

    signal loadData(int offset,int current)
    signal deleteItem(int index)

    onMusicListChanged: {
        listViewModel.clear()
        if (Array.isArray(musicList)) {
            for (let i = 0; i < musicList.length; i++) {
                listViewModel.append(musicList[i])
            }
        }
    }

    Layout.fillHeight: true
    Layout.fillWidth: true

    clip: true
    padding: 0

    background: Rectangle{
        color: "#00000000"
    }

    ListView{
        id:listView
        anchors.fill: parent
        anchors.bottomMargin: 50
        model: ListModel {
            id: listViewModel
        }
        delegate: listViewDelegate   //定义了列表中每个项目的外观和行为。
        ScrollBar.vertical: ScrollBar{   //设置了垂直滚动条的属性，使其始终位于父组件的右侧。
            anchors.right: parent.right
        }
        header: listViewHeader
//        highlight: Rectangle{
//            color: "#f0f0f0"
//        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
    }

    Component{
        id:listViewDelegate
        Rectangle{
            id : listViewDelegateItem
            height: 45
            width: listView.width
            color: "#00000000"

            Shape{
                anchors.fill: parent
                ShapePath{   //定义了形状的路径，它是形状的绘制部分。
                    strokeWidth: 0
                    strokeColor: "#50000000"
                    strokeStyle: ShapePath.SolidLine
                    startX: 0  //设置路径的起始点在父元素的左上角（坐标原点）
                    startY: 45
                    PathLine{
                        x:0
                        y:45
                    }
                    PathLine{ //第二个PathLine元素定义了一条从起点（0,0）到父元素宽度的（parent.width,0）的水平线
                        // x:parent.width
                        y:45
                    }
                }
            }

            MouseArea{
                RowLayout{
                    width: parent.width
                    height: parent.height
                    spacing: 15
                    x:5
                    Text{
                        text:index+1+pageSize*current
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.1
                        font.family: Style.fontFamily
                        font.pointSize: 13
                        color: "white"
                        elide: Qt.ElideRight
                    }
                    Text{
                        text:name
                        Layout.preferredWidth: parent.width*0.3
                        font.family: Style.fontFamily
                        font.pointSize: 13
                        color: "white"
                        elide: Qt.ElideRight
                    }
                    Text{
                        text:artist
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.family: Style.fontFamily
                        font.pointSize: 13
                        color: "white"
                        elide: Qt.ElideRight
                    }
                    Text{
                        text:album
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.15
                        font.family: Style.fontFamily
                        font.pointSize: 13
                        color: "white"
                        elide: Qt.ElideRight
                    }
                    Item {
                        Layout.preferredWidth: parent.width*0.2
                        RowLayout{
                            anchors.centerIn: parent
                            MusicIconButton{
                                iconSource: "qrc:/resources/music_icons/pause"
                                iconHeight:16
                                iconWidth: 16
                                toolTip: "播放"
                                onClicked: {
                                    layoutBottomView.current = -1
                                    layoutBottomView.playList = musicList
                                    layoutBottomView.current = index
                                }
                            }
                            MusicIconButton{
                                visible: favoritable
                                iconSource: "qrc:/resources/music_icons/favorite"
                                iconHeight:16
                                iconWidth: 16
                                toolTip: "喜欢"

                                onClicked: {
                                    layoutBottomView.saveFavorite({
                                        id: musicList[index].id,
                                        name: musicList[index].name,
                                        artist: musicList[index].artist,
                                        url: musicList[index].url || "",
                                        type: musicList[index].type || "0",
                                        album: musicList[index].album || "网络音乐"
                                    })
                                    
                                    notification.openSuccess("已添加到我喜欢的音乐")
                                }
                            }
                            MusicIconButton{
                                visible: deleteable
                                iconSource: "qrc:/resources/music_icons/clear"
                                iconHeight:16
                                iconWidth: 16
                                toolTip: "删除"
                                onClicked: deleteItem(index)
                            }
                        }
                    }
                }

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    color = "#15f0f0f0"    //ffffff 白色
                }
                onExited: {
                    color = "#00000000"
                }
                onClicked: {
                    listViewDelegateItem.ListView.view.currentIndex = index
                }
            }
        }
    }

    Component{
        id:listViewHeader
        Rectangle{
            color: "#00000000"
            height: 45
            width: listView.width
            RowLayout{
                width: parent.width
                height: parent.height
                spacing: 15
                x:5
                Text{
                    text:"序号"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.1
                    font.family: Style.fontFamily
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"歌名"
                    Layout.preferredWidth: parent.width*0.3
                    font.family: Style.fontFamily
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"歌手"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: Style.fontFamily
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"专辑"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: Style.fontFamily
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"操作"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.2
                    font.family: Style.fontFamily
                    font.pointSize: 13
                    color: "white"
                    elide: Qt.ElideRight
                }
            }
        }
    }

    Item{
        id:pageButton
        visible: Boolean(musicList) && Array.isArray(musicList) && musicList.length > 0
        width: parent.width
        height: 40
        anchors.top: listView.bottom
        anchors.topMargin: 20
        ButtonGroup{
            buttons:buttons.children
        }
        RowLayout{
            id:buttons
            anchors.centerIn: parent
            Repeater{
                id:repeater
                model: all/pageSize>9?9:all/pageSize
                Button{
                    Text{
                        anchors.centerIn: parent
                        text: modelData +1
                        font.family: Style.fontFamily
                        font.pointSize: 14
                        color: checked?"white":"#497563"
                    }
                    background: Rectangle{
                        implicitHeight: 30
                        implicitWidth: 30
                        color: checked?"#10e9f4ff":"#20e9f4ff"
                        radius: 3
                    }
                    checkable: true
                    checked: modelData === current
                    onClicked: {
                        if(current === index)return
                        loadData(current*pageSize,index)
                    }
                }
            }
        }
    }

    //    function playMusic(index = 0){
    //        //播放
    //        if(musicList.length<1) return
    //        var id = musicList[index].id
    //        console.log(id)
    //        console.log("--------------------------")
    //        if(!id) return

    //        function onReply(reply){
    //            http.onReplySignal.disconnect(onReply)
    //            var url = JSON.parse(reply).data[0].url
    //            if(!url) return
    //            mediaPlayer.source = url
    //            mediaPlayer.play()
    //        }

    //        http.onReplySignal.connect(onReply)
    //        http.connet("song/url?id="+id)
    //    }
}
