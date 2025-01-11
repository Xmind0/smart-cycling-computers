import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Style


ScrollView{
    id: scrollView
    clip: true
    
    // 设置ScrollView的宽度和高度
    width: parent.width  

    ColumnLayout {
        // 设置ColumnLayout的宽度为ScrollView的宽度
        width: scrollView.width
        
        // 移除Layout.fillWidth，因为我们已经明确设置了宽度
        Rectangle {
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x: 10
                verticalAlignment: Text.AlignBottom
                text: qsTr("推荐内容")
                font.family: Style.fontFamily
                font.pointSize: 25
                color: "white"
            }
        }

        MusicBannerView{
            id:bannerView
            Layout.preferredWidth: parent.width-300
            Layout.preferredHeight: (parent.width)*0.3
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: {
                console.log("MusicBannerView width:", parent.width)
                console.log("MusicBannerView parent:", parent)
            }
        }

        //热门歌单
        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: Style.fontFamily
                font.pointSize: 25
                color: "white"
            }
        }
        MusicGridHotView{
            id:hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (parent.width-250)*0.2*4+30*4+20+20+40+40+40
            Layout.bottomMargin: 20
        }
        //新歌推荐
        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌推荐")
                font.family: Style.fontFamily
                font.pointSize: 25
                color: "white"
            }
        }

        MusicGridLatestView{
            id:latestView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (parent.width-230)*0.1*10+20
            Layout.bottomMargin: 20
        }
    }


    Component.onCompleted: {
        getBannerList()
        getHotList()
        getLatestList()
    }

    function getBannerList(){
        loading.open()
        function onReply(requestId, reply){
            if(requestId !== "banner") return; // 只处理banner请求的响应
            
            http.replySignal.disconnect(onReply)
            loading.close()

            try{
                if(reply.length<1){
                    notification.openError("请求banner为空！")
                    return
                }

                var banners = JSON.parse(reply).banners
                bannerView.bannerList = banners
                // getHotList()

            }catch(err){
                notification.openError("请求banner错误！")
            }
        }

        http.replySignal.connect(onReply)
        http.get("banner", "banner")
    }

    function getHotList(){
        loading.open()
        function onReply(requestId, reply){
            if(requestId !== "hotlist") return; // 只处理热门列表请求的响应
            
            http.replySignal.disconnect(onReply)
            loading.close()

            try{
                if(reply.length<1){
                    notification.openError("请求热门推荐为空！")
                    return
                }
                var playlists = JSON.parse(reply).playlists
                hotView.list = playlists
                // getLatestList()
            }catch(err){
                notification.openError("请求热门推荐错误！")
            }
        }

        http.replySignal.connect(onReply)
        http.get("top/playlist/highquality?limit=20", "hotlist")
    }

    function getLatestList(){
        loading.open()
        function onReply(requestId, reply){
            if(requestId !== "latest") return; // 只处理最新歌曲请求的响应
            
            http.replySignal.disconnect(onReply)
            loading.close()

            try{
                if(reply.length<1){
                    notification.openError("请求最新歌曲为空！")
                    return
                }
                var latestList = JSON.parse(reply).data
                latestView.list = latestList.slice(0,30)
            }catch(err){
                notification.openError("请求最新歌曲为空！")
            }
        }

        http.replySignal.connect(onReply)
        http.get("top/song", "latest")
    }
}

