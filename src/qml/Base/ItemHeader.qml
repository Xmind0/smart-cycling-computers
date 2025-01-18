import QtQuick
import QtQuick.Controls



// 添加返回箭头
Item {

    id: backItem
    width: parent.width
    height: 38

    signal backAnimationFinished()

    Image {
        id: backArrow
        source: "qrc:/resources/app_icons/arrow-down.svg"
        width: 30
        height: 30
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            backAnimation.start()
        }
    }

    NumberAnimation {
        id: backAnimation
        target: parent
        property: "y"
        from: 0
        to: parent.parent.height
        duration: 300
        easing.type: Easing.InOutQuad
        onFinished: {
            parent.visible = !parent.visible
            root.showFullItem = !root.showFullItem
            parent.y = 0; // 重置位置
            backItem.backAnimationFinished()
        }
    }
}
