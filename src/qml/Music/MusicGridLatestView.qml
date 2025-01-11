//MusicGridLatestView.qml

import QtQuick
import QtQuick.Controls
import QtQml
import Style


Item{

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill:parent
        columns: 3
        Repeater{
            id:gridRepeater
            Frame{
                required property var modelData

                padding: 5
                width: parent.width*0.333
                height: parent.width*0.1
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }

                clip: true

                MusicRoundImage{
                    id:img
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: modelData.album.picUrl
                }
                Text{
                    id:name
                    anchors{
                        left: img.right
                        verticalCenter: parent.verticalCenter
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text:modelData.album.name
                    font.family: Style.fontFamily
                    font.pointSize: 11
                    height:30
                    width: parent.width*0.72
                    elide: Qt.ElideRight
                    color: "white"
                }
                Text{
                    anchors{
                        left: img.right
                        top: name.bottom
                        leftMargin: 5
                    }
                    text:modelData.artists[0].name
                    font.family: Style.fontFamily
                    height:30
                    width: parent.width*0.72
                    elide: Qt.ElideRight
                    color: "white"
                }


                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    // cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                }
            }
        }
    }
}
