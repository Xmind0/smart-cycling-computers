import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Qt5Compat.GraphicalEffects

Item {
    property string imgSrc: "qrc:/resources/music_icons/player"

    property int borderRadius: 5

    Image {
        id: image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true
        visible: false
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        // zantialiasing: true
    }

    Rectangle{
        id:mask
        color: "black"
        anchors.fill: parent
        radius: borderRadius      // ?? borderRadius 和 5 的区别
        visible: false
        smooth: true
        // antialiasing: true
    }

    OpacityMask{
        anchors.fill: image
        source:image
        maskSource:  mask
        visible: true
        // antialiasing: true
    }
}
