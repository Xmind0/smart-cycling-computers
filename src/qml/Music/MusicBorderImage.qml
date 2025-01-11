import QtQuick 2.12
import QtQuick.Controls 2.5
import Qt5Compat.GraphicalEffects

Rectangle {
    property string imgSrc: "qrc:/resources/music_icons/player"
    property int borderRadius: 5
    property bool isRotating: false
    property real rotationAngel: 0.0

    radius:borderRadius

    gradient: Gradient{
        GradientStop{
            position: 0.0
            color: "#101010"
        }
        GradientStop{
            position: 0.5
            color: "#a0a0a0"
        }
        GradientStop{
            position: 1.0
            color: "#505050"
        }
    }

    Image {
        id: image
        anchors.centerIn: parent
        source: "qrc:/resources/music_icons/player"
        smooth: true
        visible: false
        width: parent.width*0.9
        height: parent.height*0.9
        fillMode: Image.PreserveAspectCrop
        // antialiasing: true
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
        id:maskImage
        anchors.fill: image
        source:image
        maskSource:  mask
        visible: true
        // antialiasing: true
    }

    NumberAnimation{
        running: isRotating
        loops: Animation.Infinite
        target: maskImage
        from:rotationAngel
        to:360+rotationAngel
        property: "rotation"
        duration: 100000
        onStopped: {
            rotationAngel = maskImage.rotation
        }
    }
}
