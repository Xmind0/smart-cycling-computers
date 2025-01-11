import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ToolButton{
        property string iconSource: ""   //封装数据 重用 类型检查

        property string toolTip: ""

        property bool isCheckable:false
        property bool isChecked:false

        property int iconWidth: 32
        property int iconHeight: 32

        id:self

        icon.source:iconSource

        // MusicToolTip{
        //     visible: hovered
        //     text: toolTip
        // }

//        ToolTip.visible: hovered
//        ToolTip.text: toolTip

        background: Rectangle{
            color: self.down||(isCheckable&&self.checked)?"#eeeeee":"#00000000"

        }
        icon.color: self.down||(isCheckable&&self.checked)?"#00000000":"#eeeeee"

        checkable: isCheckable
        checked: isChecked
    }
