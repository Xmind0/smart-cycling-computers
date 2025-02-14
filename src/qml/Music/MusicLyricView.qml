
import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQml 2.12
import Style

Rectangle {

    property alias lyrics: list.model
    property alias current: list.currentIndex

    id:lyricView

    Layout.preferredHeight:parent.height*0.8
    Layout.alignment: Qt.AlignHCenter

    clip: true

    //
    ListView{
        id:list
        anchors.fill: parent
        model:["暂无歌词","XXX","XXX"]
        delegate: listDelegate
//        highlight: Rectangle{
//            color: "#2073a7db"
//        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        currentIndex: 0
        preferredHighlightBegin: parent.height/2-50
        preferredHighlightEnd: parent.height/2
        highlightRangeMode: ListView.StrictlyEnforceRange    //根据highlight调整
    }

    Component{
        id:listDelegate
        Item{
            id:delegateItem
            width: parent.width
            height: 50
            Text{
                text:modelData
                anchors.centerIn: parent
                color: index===list.currentIndex?"black":"#505050"
                font.family: Style.fontFamily
                font.pointSize: 12

            }
            states:State{
                when:delegateItem.ListView.isCurrentItem
                PropertyChanges{
                    target: delegateItem
                    scale:1.2
                }
            }
            MouseArea{
                anchors.fill: parent
                onCanceled: list.currentIndex = index
            }
        }
    }

}
