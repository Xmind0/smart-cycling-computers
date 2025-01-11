import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Style
import Qt5Compat.GraphicalEffects

Item {
    height: 84
    width: parent.width

    TopLeftControl {
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
    }

    TopMiddleControl {
        anchors.centerIn: parent
    }

    TopRightControl {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 16
        // width: 16     取消特定大小
        // height: 16
    }
    Component.onCompleted: {

    }
}
