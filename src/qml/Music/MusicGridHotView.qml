import QtQuick
import QtQuick.Controls
import QtQml

Item{

    property alias list: gridRepeater.model

    Grid{

        id:gridLayout
        width:parent.width

        anchors.fill:parent
        columns: 5
        Repeater{
            id:gridRepeater
            delegate: Frame{

                padding: 10
                width: parent.width*0.2
                height: parent.width*0.2+30
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }
                clip: true

                MusicRoundImage{
                    id:img
                    width: parent.width
                    height: parent.width
                    imgSrc: {
                        if (modelData && modelData.coverImgUrl) {
                            return modelData.coverImgUrl
                        }
                        return "qrc:/resources/music_icons/player"
                    }
                }

                Text{
                    anchors{
                        top:img.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    text:modelData.name
                    font.family: "微软雅黑"
                    height:30
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Qt.ElideMiddle
                    color: "white"
                }


                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                    onClicked: {
                        var item  = gridRepeater.model[index]
                        pageHomeView.showPlayList(item.id,"1000")
                    }
                }
            }
        }
    }
}
