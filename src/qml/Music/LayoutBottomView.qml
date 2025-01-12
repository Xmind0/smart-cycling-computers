//layoutBottomView.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtQml
import Style
import QtQuick.Dialogs


Rectangle{
    property var playList: []  //在MusicListView里面赋值
    property int current: -1

    property int sliderFrom: 0
    property int sliderValue: 0
    property int sliderTo: 100

    property int currentPlayMode: 0
    property var playModeList: [{icon:"single-repeat",name:"单曲循环"},
        {icon:"repeat",name:"顺序播放"},{icon:"random",name:"随机播放"}]

    property bool playbackStateChangeCallbackEnabled: false

    property string musicName: ""
    property string musicArtist: ""
    property string musicCover: ""

    property int playingState: 0
    Layout.fillWidth: true
    height: 100
    color: "#1000AAAA"

    RowLayout{
        anchors.fill: parent

        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
            Layout.fillHeight:  true
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: layoutHeaderView.setPoint(mouseX,mouseY)
                onMouseXChanged: layoutHeaderView.moveX(mouseX)
                onMouseYChanged: layoutHeaderView.moveY(mouseY)
            }
        }
        MusicIconButton{
            icon.source: "qrc:/resources/music_icons/previous"
            iconWidth: 32
            iconHeight: 32
            toolTip: "上一曲"
            onClicked: playPrevious()
        }
        MusicIconButton{
            iconSource: playingState===0?"qrc:/resources/music_icons/pause":"qrc:/resources/music_icons/stop"
            iconWidth: 32
            iconHeight: 32
            toolTip: playingState===0?"暂停":"播放"
            onClicked: playOrPause()

        }
        MusicIconButton{
            icon.source: "qrc:/resources/music_icons/next"
            iconWidth: 32
            iconHeight: 32
            toolTip: "下一曲"
            onClicked: playNext()
        }
        Item {
            // visible: !layoutHeaderView.isSmallWindow
            visible: true
            Layout.preferredWidth: parent.width/2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 25

            Text {
                id: nameText
                anchors.left: slider.left
                anchors.bottom: slider.top
                Layout.bottomMargin: 5
                anchors.leftMargin: 5
                text: musicName+"-"+musicArtist
                font.family: Style.fontFamily
                color: "#ffffff"
            }

            Text {
                id: timeText
                anchors.right: slider.right
                anchors.bottom: slider.top
                Layout.bottomMargin: 5
                anchors.leftMargin: 5
                text: "timetext"
                font.family: Style.fontFamily
                color: "#ffffff"
            }

            Slider{
                id: slider
                width: parent.width
                Layout.fillWidth: true
                to:sliderTo
                from:sliderFrom
                value:sliderValue

                onMoved: {
                        mediaPlayer.setPosition(value)
                        console.log("sliderValue:"+sliderValue)
                        console.log("value:"+value)
                }

                height: 25
                background: Rectangle{
                    x: slider.leftPadding
                    y: slider.topPadding +(slider.availableHeight-height)/2
                    width: slider.availableWidth
                    height: 4
                    radius: 2
                    color: "#e9f4ff"
                    Rectangle{
                        width: slider.visualPosition*parent.width
                        height: parent.height
                        color: "#73a7ab"
                    }
                }
                handle:Rectangle{
                    x: slider.leftPadding + (slider.availableWidth-width)*slider.visualPosition
                    y: slider.topPadding +(slider.availableHeight-height)/2
                    width: 15
                    height: 15
                    radius: 5
                    color: "#f0f0f0"
                    border.color: "#73a7ab"

                }
            }
        }

        MusicBorderImage{
            imgSrc: musicCover
            visible: true
            // visible: !layoutHeaderView.isSmallWindow
            width:50
            height: 45
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onPressed: {
                    parent.scale=0.9
                    pageDetailView.visible = ! pageDetailView.visible
                    pageHomeView.visible = ! pageHomeView.visible
                    appBackground.showDefaultBackground = !appBackground.showDefaultBackground
                }
                onReleased:{
                    parent.scale=1.0
                }

            }
        }

        MusicIconButton{
            icon.source: "qrc:/resources/music_icons/favorite"
            iconWidth: 32
            iconHeight: 32
            toolTip: "我喜欢"
            onClicked: saveFavorite(playList[current])
        }
        MusicIconButton{
            icon.source: "qrc:/resources/music_icons/" + playModeList[currentPlayMode].icon
            iconWidth: 32
            iconHeight: 32
            toolTip: playModeList[currentPlayMode].name
            onClicked: changePlayMode()
        }
        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
            Layout.fillHeight:  true

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                // onPressed: layoutHeaderView.setPoint(mouseX,mouseY)
                onMouseXChanged: layoutHeaderView.moveX(mouseX)
                onMouseYChanged: layoutHeaderView.moveY(mouseY)
            }
        }
    }

    onPlayListChanged: {
        if (!playList) {
            playList = []
            return
        }
        
        if (!Array.isArray(playList)) {
            console.log("Warning: playList is not an array, converting...")
            playList = [playList]
        }
    }

    onCurrentChanged: {
        // 基础验证
        if (current < 0 || !playList || !Array.isArray(playList) || playList.length === 0) {
            resetPlayState()
            return
        }

        // 处理循环播放
        if (current >= playList.length) {
            current = 0
        }

        const currentItem = playList[current]
        if (!currentItem) {
            resetPlayState()
            return
        }

        // 设置基本音乐信息
        musicName = currentItem.name || "未知歌曲"
        musicArtist = currentItem.artist || "未知歌手"
        musicCover = currentItem.cover || "qrc:/resources/music_icons/player"

        // 根据音乐类型选择播放方式
        if (currentItem.type === "1") {
            playLocalMusic()
        } else {
            playWebMusic()
        }
    }

    function resetPlayState() {
        mediaPlayer.stop()
        musicName = "未播放"
        musicArtist = ""
        musicCover = "qrc:/resources/music_icons/player"
        setSlider(0, 100, 0)
    }

    function playLocalMusic() {
        var currentItem = playList[current]
        if (!currentItem || !currentItem.url) {
            notification.openError("无效的本地音乐文件")
            return
        }

        mediaPlayer.source = currentItem.url
        mediaPlayer.play()
        saveHistory(current)
    }

    Component.onCompleted: {
        //从配置文件中拿到currentPlayMode
        currentPlayMode = settings.currentPlayMode || 0
    }

    function saveHistory(index = 0){
        if(playList.length<index+1) return
        var item = playList[index]
        // var history = historySettings.value("history",[])
        var history = historySettings.history || []
        console.log(history)
        // console.log("value"+value.id)
        console.log("value"+item.id)
        var i = history.findIndex(value=>value.id === item.id)

        if(i>=0){
            history.slice(i,1)
        }
        history.unshift({
                            id:item.id+"",
                            name:item.name+"",
                            artist:item.artist+"",
                            url:item.url?item.url:"",
                            cover:item.cover?item.cover:"",
                            type:item.type?item.type:"",
                            album:item.album? item.album:"本地音乐"
                        })
        if(history.length>500){
            //限制100条
            history.pop()
        }

        historySettings.setValue("history",history)
        console.log("unfinished")
    }


    function saveFavorite(value={}) {
        if(!value || !value.id) return
        
        // 从设置中读取并解析
        var favorite = []
        try {
            var savedData = favoriteSettings.value("favorite", "[]")
            favorite = JSON.parse(savedData)
            if (!Array.isArray(favorite)) {
                favorite = []
            }
        } catch(e) {
            console.log("Error parsing favorite:", e)
            favorite = []
        }

        // 创建新的收藏项，确保所有值都是字符串
        var newItem = {
            id: String(value.id || ""),
            name: String(value.name || ""),
            artist: String(value.artist || ""),
            url: String(value.url || ""),
            cover: String(value.cover || ""),
            type: String(value.type || "0"),
            album: String(value.album || "网络音乐")
        }

        // 查找并移除已存在的项
        favorite = favorite.filter(function(item) {
            return item.id !== newItem.id
        })
        
        // 添加到开头
        favorite.unshift(newItem)
        
        // 限制数量
        if(favorite.length > 500) {
            favorite = favorite.slice(0, 500)
        }
        
        // 保存为JSON字符串
        try {
            var jsonString = JSON.stringify(favorite)
            favoriteSettings.setValue("favorite", jsonString)
            notification.openSuccess("已添加到我喜欢的音乐")
            
            // 尝试更新收藏列表视图
            var favoriteView = pageHomeView?.contentItem?.children?.find(child => 
                child?.objectName === "DetailFavoritePageView"
            )
            if (favoriteView) {
                favoriteView.getFavorite()
            }
        } catch(e) {
            console.log("Error saving favorite:", e)
            notification.openError("收藏失败")
        }
    }

    function playPrevious(){
        if(playList.length<1)return
        switch(currentPlayMode){
        case 0:
            mediaPlayer.play()
            break
        case 1:
            current = (current+playList.length-1)%playList.length
            break
        case 2:{
            var random = parseInt(Math.random()*playList.length)
            current = current === random?random+1:random
            break
        }
        }
    }

    function playOrPause(){

        if(!mediaPlayer.source) return
        if(mediaPlayer.playbackState===MediaPlayer.PlayingState){
            mediaPlayer.pause()
        }else if(mediaPlayer.playbackState===MediaPlayer.PausedState){
            mediaPlayer.play()
        }
    }

    function playNext(){
        if(playList.length<1)return
        switch(currentPlayMode){
        case 0:
            mediaPlayer.play()
            break
        case 1:
            current = (current+1)%playList.length
            break
        case 2:{
            var random = parseInt(Math.random()*playList.length)
            current = current === random?random+1:random
            break
        }
        }
    }

    function changePlayMode(){
        currentPlayMode = (currentPlayMode+1)%playModeList.length
        settings.setValue("currentPlayMode",currentPlayMode)
    }

    function playWebMusic(){
            loading.open()
            //播放
            var id = playList[current].id
            if(!id) return

            //设置详情
            musicName = playList[current].name
            musicArtist = playList[current].artist

        function onReply(requestId, reply) {
            if(requestId !== "songurl") return;
            loading.close()
            http.replySignal.disconnect(onReply)
            // try {
                if(reply.length<1) {
                    notification.openError("请求歌曲链接为空！")
                    return
                }
                    var data = JSON.parse(reply).data[0]
                    var url = data.url
                    var time = data.time



                    //设置Slider
                    setSlider(0,time,0)

                    if(!url) return

                    var cover = playList[current].cover
                    if(cover.length<1) {
                        //请求Cover
                        getCover(id)
                    }else{
                        musicCover = cover
                        getLyric(id)
                    }

                    mediaPlayer.source = url
                    mediaPlayer.play()
                    saveHistory(current)

                    playbackStateChangeCallbackEnabled =true
                // }catch(err){
                //     notification.openError("请求歌曲链接出错！")
                //     console.log(err.stack)
                // }
            }

        http.replySignal.connect(onReply)
        http.get("song/url?id="+id, "songurl")
        console.log("song/url?id="+id)
    }

        function setSlider(from=0,to=100,value=0){
            sliderFrom = from
            sliderTo = to
            sliderValue = value

            var va_mm = parseInt(value/1000/60)+""
            va_mm = va_mm.length<2?"0"+va_mm:va_mm
            var va_ss = parseInt(value/1000%60)+""
            va_ss = va_ss.length<2?"0"+va_ss:va_ss

            var to_mm = parseInt(to/1000/60)+""
            to_mm = to_mm.length<2?"0"+to_mm:to_mm
            var to_ss = parseInt(to/1000%60)+""
            to_ss = to_ss.length<2?"0"+to_ss:to_ss

            timeText.text = va_mm+":"+va_ss+"/"+to_mm+":"+to_ss
        }

        function getCover(id){
            loading.open()
            function onReply(requestId, reply){
                if(requestId !== "songdetail") return;
                loading.close()
                http.onReplySignal.disconnect(onReply)

                //请求歌词
                getLyric(id)

                if(!reply) {
                    notification.openError("获取歌曲详情失败")
                    return
                }

                try {
                    if(reply.length < 1) {
                        notification.openError("请求歌曲图片为空！")
                        return
                    }
                    var song = JSON.parse(reply).songs[0]
                    var cover = song.al.picUrl
                    musicCover = cover
                    if(musicName.length < 1) musicName = song.name
                    if(musicArtist.length < 1) musicArtist = song.ar[0].name
                } catch(err) {
                    notification.openError("请求歌曲图片出错！")
                }
            }

        http.replySignal.connect(onReply)
        http.get("song/detail?ids="+id, "songdetail")
    }


        function getLyric(id){
            loading.open()
            function onReply(requestId, reply){
                if(requestId !== "lyric") return;
                loading.close()
                http.onReplySignal.disconnect(onReply)

                try{
                    if(reply.length<1){
                        notification.openError("请求歌曲歌词为空！")
                        return
                    }
                    var lyric = JSON.parse(reply).lrc.lyric
                    if(lyric.length<1) return
                    var lyrics = (lyric.replace(/\[.*\]/gi,"")).split("\n")

                    if(lyrics.length>0) pageDetailView.lyrics = lyrics

                    var times = []
                    lyric.replace(/\[.*\]/gi,function(match,index){
                        //match : [00:00.00]
                        if(match.length>2){
                            var time  = match.substr(1,match.length-2)
                            var arr = time.split(":")
                            var timeValue = arr.length>0? parseInt(arr[0])*60*1000:0
                            arr = arr.length>1?arr[1].split("."):[0,0]
                            timeValue += arr.length>0?parseInt(arr[0])*1000:0
                            timeValue += arr.length>1?parseInt(arr[1])*10:0

                            times.push(timeValue)
                        }
                    })

                    mediaPlayer.times = times
                }catch(err){
                    // notification.openError("请求歌曲歌词出错！")
                }

            }
            http.onReplySignal.connect(onReply)
            console.log("the id is " + id)
            http.get("lyric?id="+id, "lyric")
        }

    }
