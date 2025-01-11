//DetailPlayListPageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Style

ColumnLayout {
    property string targetId: ""
    property string targetType: ""
    property string name: ""

    function loadAlbum() {
        loading.open()
        function onReply(requestId, reply){
            loading.close()
            if(requestId !== "Album") return;
            http.onReplySignal.disconnect(onReply);
            var album = JSON.parse(reply).album;
            var songs = JSON.parse(reply).songs;
            playListCover.imgSrc = album.blurPicUrl;
            playListDesc.text = album.description;
            name = "-" + album.name;
            playListListView.musicList = songs.map((item) => {
                return {
                    "id": item.id,
                    "name": item.name,
                    "artist": item.ar[0].name,
                    "album": item.al.name,
                    "cover": item.al.picUrl
                };
            });
        }

        var url = "album?id=" + (targetId.length < 1 ? "32311" : targetId);
        http.onReplySignal.connect(onReply);
        http.get(url,"Album");
    }

    function loadPlayList() {
        loading.open()
        function onReply(requestId, reply) {
            if(requestId !== "playlist") return;
            loading.close()
            http.replySignal.disconnect(onReply);
            
            try {
                if(reply.length<1) {
                    notification.openError("获取歌单列表为空！")
                    return
                }
                var playlist = JSON.parse(reply).playlist
                playListCover.imgSrc = playlist.coverImgUrl
                playListDesc.text = playlist.description
                name = "-"+playlist.name
                var ids = playlist.trackIds.map(item=>item.id).join(",")
                
                // 发起第二个请求
                http.replySignal.connect(onSongDetailReply)
                http.get("song/detail?ids="+ids, "songdetail")
                loading.open()
            } catch(err) {
                notification.openError("获取歌单列表出错！")
            }
        }

        var url = "playlist/detail?id=" + (targetId.length < 1 ? "32311" : targetId)
        http.replySignal.connect(onReply)
        http.get(url, "playlist")
    }

    //    1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单
    onTargetIdChanged: {
        if (targetType == "10")
            loadAlbum();
        else if (targetType == "1000")
            loadPlayList();
    }

    Component.onCompleted: {
        if (targetType === "")
            targetType = "10"; // 在组件加载完成后设置默认值

    }

    Rectangle {
        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"

        Text {
            x: 10
            verticalAlignment: Text.AlignBottom
            text: qsTr(targetType == "10" ? "专辑" : "歌单") + name
            font.family: Style.fontFamily
            font.pointSize: 25
        }

    }

    RowLayout {
        height: 200
        width: parent.width

        MusicRoundImage {
            id: playListCover

            width: 180
            height: 180
            Layout.leftMargin: 15
        }

        Item {
            Layout.fillWidth: true
            height: parent.height

            Text {
                id: playListDesc

                width: parent.width * 0.95
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere
                font.family: Style.fontFamily
                font.pointSize: 14
                maximumLineCount: 4
                elide: Text.ElideRight
                lineHeight: 1.5
                color: "white"
            }

        }

    }

    MusicListView {
        id: playListListView
        deleteable: false
    }

}
