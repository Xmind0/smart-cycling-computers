import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style


// 左边 frame 右边  Repeater
RowLayout {  //整个是一个行布局， Frame左边 Repeater创建了多个Loader组件在右边
    property var defaultIndex: 0
    property var qmlList: [{
        "icon": "recommend-white",
        "value": "推荐内容",
        "qml": "DetailRecommendPageView",
        "menu": true
    }, {
        "icon": "cloud-white",
        "value": "搜索音乐",
        "qml": "DetailSearchPageView",
        "menu": true
    }, {
        "icon": "local-white",
        "value": "本地音乐",
        "qml": "DetailLocalPageView",
        "menu": true
    }, {
        "icon": "history-white",
        "value": "播放历史",
        "qml": "DetailHistoryPageView",
        "menu": true
    }, {
        "icon": "favorite-big-white",
        "value": "我喜欢的",
        "qml": "DetailFavoritePageView",
        "menu": true
    }, {
        "icon": "favorite-big-white",
        "value": "专辑歌单",
        "qml": "DetailPlayListPageView",
        "menu": false
    }]


    function showPlayList(targetId = "", targetType = "10") {

        repeater.itemAt(menuView.currentIndex).visible = false;
        var loader = repeater.itemAt(5);
        loader.visible = true;
        loader.source = qmlList[5].qml + ".qml";
        loader.item.targetId = targetId;
        loader.item.targetType = targetType;
    }

    function hidePlayList() {
        repeater.itemAt(menuView.currentIndex).visible = true;
        var loader = repeater.itemAt(5);
        loader.visible = false;
    }

    spacing: 0 //子布局之间的距离


    Frame {

        Layout.preferredWidth: 200
        Layout.fillHeight: true //应该填充其父组件的高度
        background: Rectangle{
            color: "#2000AAAA"
        }

        padding: 0 //控件内部的边距
        Component.onCompleted: {
            //这是一个数组的 filter 方法，它遍历 qmlList 数组，并返回一个新数组，其中只包含那些 menu 属性为 true 的对象。
            //这段代码的作用是将 qmlList 数组中所有 menu 属性为 true 的菜单项添加到 menuViewModel 中
            menuViewModel.append(qmlList.filter((item) => {
                return item.menu;
            }));
            var loader = repeater.itemAt(defaultIndex);
            loader.visible = true;
            loader.source = qmlList[defaultIndex].qml + ".qml"; //加载其他qml文件
            menuView.currentIndex = defaultIndex;
        }

        ColumnLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 150

                MusicBorderImage {
                    anchors.centerIn: parent
                    height: 100
                    width: 100
                    borderRadius: 100
                }

            }

            ListView {
                id: menuView
                height: parent.height
                Layout.fillHeight: true
                Layout.fillWidth: true
                delegate: menuViewDelegate
                highlightMoveDuration: 0
                highlightResizeDuration: 0

                model: ListModel {
                    id: menuViewModel
                }

                highlight: Rectangle {
                    color: "#5073a7ab"
                }

            }

        }

        Component {
            id: menuViewDelegate

            Rectangle {
                id: menuViewDelegateItem

                height: 45
                width: 200
                color: "#00000000"

                RowLayout {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    spacing: 15

                    Item {
                        width: 30
                    }

                    Image {
                        source: "qrc:/resources/music_icons/" + icon
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                    }

                    Text {
                        text: value
                        Layout.fillWidth: true
                        height: 50
                        font.family: Style.fontFamily
                        font.pointSize: 12
                        color: "#ffffff"
                    }

                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        color = "#10000000";
                    }
                    onExited: {
                        color = "#00000000";
                    }
                    onClicked: {
                        hidePlayList();
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false;
                        //menuViewDelegateItem 是实例，是ListView委托
                        menuViewDelegateItem.ListView.view.currentIndex = index;
                        //delegate 默认加载的index
                        var loader = repeater.itemAt(index);
                        loader.visible = true;
                        loader.source = qmlList[index].qml + ".qml";
                    }
                }

            }

        }



    }

    Repeater {
        id: repeater

        model: qmlList.length

        Loader {
            visible: false
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }


}
