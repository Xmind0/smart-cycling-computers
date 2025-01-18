import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Notes
import "../Base"

Rectangle {
    id: root
    color: "black"
    radius: 10

    // 暴露组件供外部访问
    property alias notesManager: notesManager
    property alias notesModel: notesModel

    // 监听可见性变化
    onVisibleChanged: {
        if (visible) {
            refreshNotes()
        }
    }

    NotesManager {
        id: notesManager
    }

    ItemHeader {
        id: backItem
    }

    Connections {
        target: backItem
        function onBackAnimationFinished() {
            root.visible = false
            root.parent.showFullItem = false
        }
    }

    Rectangle {
        anchors {
            top: backItem.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: "black"

        GridView {
            id: gridView
            anchors.fill: parent
            anchors.margins: 10
            cellWidth: width / 3
            cellHeight: cellWidth
            model: ListModel { id: notesModel }
            
            delegate: Rectangle {
                width: gridView.cellWidth - 10
                height: gridView.cellHeight - 10
                color: "#2a2a2a"
                radius: 10

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 5

                    Text {
                        Layout.fillWidth: true
                        text: model.title
                        color: "#ffffff"
                        font.pixelSize: 16
                        font.bold: true
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                    }

                    Text {
                        Layout.fillWidth: true
                        text: model.content
                        color: "#cccccc"
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        maximumLineCount: 4
                        wrapMode: Text.Wrap
                    }

                    Text {
                        Layout.fillWidth: true
                        text: model.date
                        color: "#999999"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignRight
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        noteEditor.noteTitle = model.title
                        noteEditor.noteContent = model.content
                        noteEditor.noteFileName = model.fileName
                        noteEditor.visible = true
                    }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: "暂无笔记"
            color: "#ffffff"
            font.pixelSize: 20
            visible: gridView.count === 0
        }
    }

    // 笔记编辑器
    Rectangle {
        id: noteEditor
        visible: false
        anchors.fill: parent
        color: "#2a2a2a"
        z: 1  // 确保显示在最上层
        
        property string noteTitle: ""
        property string noteContent: ""
        property string noteFileName: ""

        Rectangle {
            id: editorHeader
            height: 50
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                
                Text {
                    text: noteEditor.noteTitle
                    color: "#ffffff"
                    font.pixelSize: 18
                    font.bold: true
                    Layout.fillWidth: true
                }

                Button {
                    text: "返回"
                    onClicked: {
                        noteEditor.visible = false
                    }
                }

                Button {
                    text: "保存"
                    onClicked: {
                        notesManager.saveNote(noteEditor.noteFileName, contentArea.text)
                        noteEditor.visible = false
                        refreshNotes()
                    }
                }
            }
        }

        ScrollView {
            anchors {
                top: editorHeader.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            anchors.margins: 10
            clip: true

            TextArea {
                id: contentArea
                text: noteEditor.noteContent
                color: "#ffffff"
                wrapMode: TextArea.Wrap
                selectByMouse: true
                background: null
                font.pixelSize: 16
            }
        }
    }

    // 公共方法：刷新笔记列表
    function refreshNotes() {
        console.log("刷新笔记列表")
        notesModel.clear()
        var savedNotes = notesManager.loadNotes()
        for (var i = 0; i < savedNotes.length; i++) {
            notesModel.append(savedNotes[i])
        }
        console.log("笔记数量:", notesModel.count)
    }

    Component.onCompleted: {
        refreshNotes()
    }
} 