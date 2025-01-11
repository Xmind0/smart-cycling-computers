import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../Base"

Item {
    id: blueWifiItem
    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.95
        radius: 10
    }

    ItemHeader{
        id: backItem
    }

    RowLayout {
        anchors.top: backItem.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        width: parent.width - 20 *2
        height: parent.height - backItem.height - 20 // 调整底部空间

        // 蓝牙设置
        GroupBox {
            title: "蓝牙设置"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width / 2 - 10
            background: Rectangle {
                color: "transparent"
                border.color: "white"
                border.width: 1
                radius: 5
            }
            label: Label {
                color: "white"
                text: parent.title
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Switch {
                    text: "蓝牙开关"
                    palette.text: "white"
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ListView {
                        width: parent.width
                        model: ListModel {
                            ListElement { name: "蓝牙设备 1" }
                            ListElement { name: "蓝牙设备 2" }
                            ListElement { name: "蓝牙设备 3" }
                        }
                        delegate: ItemDelegate {
                            text: name
                            width: parent.width
                            contentItem: Text {
                                text: name
                                color: "white"
                            }
                        }
                    }
                }

                Button {
                    text: "搜索设备"
                    Layout.alignment: Qt.AlignRight
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                    }
                    background: Rectangle {
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                        radius: 5
                    }
                }
            }
        }

        // WIFI 设置
        GroupBox {
            title: "WIFI 设置"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: parent.width / 2 - 10
            background: Rectangle {
                color: "transparent"
                border.color: "white"
                border.width: 1
                radius: 5
            }
            label: Label {
                color: "white"
                text: parent.title
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Switch {
                    text: "WIFI 开关"
                    palette.text: "white"
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ListView {
                        width: parent.width
                        model: ListModel {
                            ListElement { name: "WIFI 1"; signal: 4 }
                            ListElement { name: "WIFI 2"; signal: 3 }
                            ListElement { name: "WIFI 3"; signal: 2 }
                        }
                        delegate: ItemDelegate {
                            text: name
                            width: parent.width
                            contentItem: Text {
                                text: name
                                color: "white"
                            }
                        }
                    }
                }

                Button {
                    text: "扫描 WIFI"
                    Layout.alignment: Qt.AlignRight
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                    }
                    background: Rectangle {
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                        radius: 5
                    }
                }
            }
        }
    }
}
