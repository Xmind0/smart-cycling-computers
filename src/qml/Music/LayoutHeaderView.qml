import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12
import Style

ToolBar{

   property point point: Qt.point(x,y)
   property bool isSmallWindow: false

   background: Rectangle{
       color: "#00000000"
   }

    width: parent.width
   Layout.fillWidth: true
   RowLayout{
       anchors.fill: parent

       MusicToolButton{
           icon.source: "qrc:/resources/music_icons/music"
           toolTip: "关于"
           onClicked: {
               aboutPop.open()
           }
       }
       MusicToolButton{
           icon.source: "qrc:/resources/music_icons/about"
           toolTip: "!"
           onClicked: {
               Qt.openUrlExternally("https://www.baidu.com/s?wd=music")
           }
       }
       MusicToolButton{
           id:smallWindow
           iconSource: "qrc:/resources/music_icons/small-window"
           toolTip: "小窗播放"
           visible: !isSmallWindow
           onClicked: {
               isSmallWindow = true
               setWindowSize(330,650)
               pageHomeView.visible = false
               pageDetailView.visible = true

               appBackground.showDefaultBackground = pageHomeView.visible
           }
       }
       MusicToolButton{
           id:normalWindow
           iconSource: "qrc:/resources/music_icons/exit-small-window"
           toolTip: "退出小窗播放"
           visible: isSmallWindow
           onClicked: {
               setWindowSize()
               isSmallWindow = false
               appBackground.showDefaultBackground = pageHomeView.visible
           }
       }
       Item{
           Layout.fillWidth: true
           height: 32
           Text {
               anchors.centerIn: parent
               text: qsTr("xxx")
               font.family: Style.fontFamily
               font.pointSize: 15
               color:"#ffffff"
           }

           MouseArea{
               anchors.fill: parent
               acceptedButtons: Qt.LeftButton
               onPressed:  setPoint(mouseX,mouseY)
               onMouseXChanged: moveX(mouseX)
               onMouseYChanged: moveY(mouseY)
           }
       }
       MusicToolButton{
           icon.source: "qrc:/resources/music_icons/minimize-screen"
           toolTip: "最小化"
           onClicked: {
               window.hide()
           }
       }
       MusicToolButton{
           id:resize
           icon.source: "qrc:/resources/music_icons/small-screen"
           toolTip: "退出全屏"
           visible: false
           onClicked: {
               setWindowSize()
               window.visibility = Window.AutomaticVisibility
               maxWindow.visible = true
               resize.visible = false
           }
       }
       MusicToolButton{
           id:maxWindow
           icon.source: "qrc:/resources/music_icons/full-screen"
           toolTip: "全屏"
           onClicked: {
               window.visibility = Window.Maximized
               maxWindow.visible = false
               resize.visible = true
           }
       }
       MusicToolButton{
           icon.source: "qrc:/resources/music_icons/power"
           toolTip: "退出"
           onClicked: {
               Qt.quit()
           }
       }
    }

   Popup{                                 //点其他地方就可以关闭
       id:aboutPop

       topInset: 0
       leftInset: 0
       rightInset: 0

       parent: Overlay.overlay
       x:(parent.width-width)/2
       y:(parent.height-height)/2

       width: 250
       height: 230

       background: Rectangle{
           color: "#e9f4ff"
           radius: 5
           border.color: "#2273a7ab"
       }

       contentItem: ColumnLayout{
           width: parent.width
           height:  parent.height
           Layout.alignment: Qt.AlignHCenter

           Image {
               Layout.preferredHeight: 60
               source: "qrc:/resources/music_icons/music"
               Layout.fillWidth: true
               fillMode: Image.PreserveAspectFit
           }

           Text {
               text: qsTr("text1")
               Layout.fillWidth: true
               horizontalAlignment: Text.AlignHCenter
               font.pixelSize: 18
               color: "#8573a7ab"
               font.family: Style.fontFamily
               font.bold: true
           }
           Text {
               text: qsTr("text2")
               Layout.fillWidth: true
               horizontalAlignment: Text.AlignHCenter
               font.pixelSize: 18
               color: "#8573a7ab"
               font.family: Style.fontFamily
               font.bold: true
           }
       }
   }


   function setWindowSize(width = window.mWINDOW_WIDTH,height = window.mWINDOW_HEIGHT){
       window.width = width
       window.height = height
       window.x=(Screen.desktopAvailableWidth-window.width)/2
       window.y=(Screen.desktopAvailableHeight-window.height)/2
   }
   function setPoint(mouseX =0 ,mouseY = 0){
       point =Qt.point(mouseX,mouseY)
       console.log(mouseX,mouseY)
   }

   function moveX(mouseX = 0 ){
       var x = window.x + mouseX-point.x
       if(x<-(window.width-70)) x = - (window.width-70)
       if(x>Screen.desktopAvailableWidth-70) x = Screen.desktopAvailableWidth-70
       window.x = x
   }
   function moveY(mouseY = 0 ){
       var y = window.y + mouseY-point.y
       if(y<=0) y = 0
       if(y>Screen.desktopAvailableHeight-70) y = Screen.desktopAvailableHeight-70
       window.y = y
   }
}
