import QtQuick
import QtQuick.Controls
import QtQml
import QtQuick.Layouts
import Style

Frame{
    property int current: 0
    property alias bannerList : bannerView.model //别名

 //    property alias testList: imageRepeater.model
    // RowLayout{
    //     width: parent.width
    //     RowLayout {
    //         height: 120
    //         spacing: 10
    //         Repeater {
    //             id: imageRepeater
    //             model: 0  // 初始为0,等数据加载完再更新
    //             delegate:
    //             MusicRoundImage{
    //                 Layout.preferredWidth: 100
    //                 Layout.preferredHeight: 100
    //                 // imgSrc: modelData.coverImgUrl || ""
    //                 Component.onCompleted:{
    //                 }
    //             }
    //         }
    //         Component.onCompleted: {

    //             function onReply(reply) {
    //                 http.onReplySignal.disconnect(onReply)
    //                 try {
    //                     if(reply.length < 1) return
    //                     var playlists = JSON.parse(reply).playlists
    //                     imageRepeater.model = playlists  // 直接更新model
    //                 } catch(err) {
    //                     console.error("加载推荐列表失败:", err)
    //                 }
    //             }
    //             http.onReplySignal.connect(onReply)
    //             http.connet("top/playlist/highquality?limit=20")
    //         }
    //     }
    // }

    background: Rectangle{
        color: "#00000000"  //设置背景，让框线消失
    }
    PathView{
        id:bannerView
        width: parent.width
        height: parent.height

        clip: true
        MouseArea{
            // cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                bannerTimer.stop()
            }
            onExited: {
                bannerTimer.start()
            }
        }
        delegate: Item {
            id:delegateItem
            width:bannerView.width*0.7
            height: bannerView.height
            z:PathView.z? PathView.z:0
            scale: PathView.scale? PathView.scale:0 //防止跨越多个错误

            MusicRoundImage{
                id:image
                imgSrc:modelData.imageUrl
                width: delegateItem.width
                height: delegateItem.height
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true   //悬停事件
                // cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(bannerView.currentIndex ===index ){
                        var item = bannerView.model[index]
                        var targetId = item.targetId+""
                        var targetType = item.targetType+"" //1:single song 10: album 1000:song list
                        switch(targetType){
                        case "1":
                            LayoutBottomView.current = -1
                            layoutBottomView.playList=[{id:targetId,name:"",artist:"",cover:"",album:""}]
                            layoutBottomView.current = 0
                            break
                        case "10":
                        case "1000":
                            pageHomeView.showPlayList(targetId,targetType)
                            break

                        }
                    }else{
                        bannerView.currentIndex = index
                    }
                }
            }
        }

        pathItemCount: 3 //路径上都会有三个项目可见。
        path:bannerPath
        preferredHighlightBegin: 0.5   //把中间的highlight
        preferredHighlightEnd: 0.5
    }

    Path{
        id:bannerPath

        //起点
        startX: 0
        startY: bannerView.height/2

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}
        //缩放的大小

        //中间点
        PathLine{   //直线
            x:bannerView.width/2
            y:bannerView.height/2
        }

        PathAttribute{name:"z";value:2}
        PathAttribute{name:"scale";value:0.9}

        //结束点
        PathLine{
            x:bannerView.width
            y:bannerView.height/2
        }

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}
    }

    PageIndicator{
        id:indicator
        anchors{
            top: bannerView.bottom
            horizontalCenter: parent.horizontalCenter
        }
        count: bannerView.count
        currentIndex: bannerView.currentIndex
        spacing: 10
        delegate: Rectangle{
            width: 10
            height: 5
            radius: 5
            color:  index === bannerView.currentIndex?"white":"#55000000"
            Behavior on color {

                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea{
                // cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    bannerTimer.stop()
                    bannerView.currentIndex = index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }

    }
    Timer{
        id:bannerTimer
        running: true
        repeat: true
        interval: 3000
        onTriggered: {
            if( bannerView.count > 0)
                bannerView.currentIndex = ( bannerView.currentIndex+1)%bannerView.count
        }
    }
    Component.onCompleted: {
    }
}

