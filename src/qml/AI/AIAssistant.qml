import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Base"
import Style
import "."
import SpeechRecognition 1.0
import Notes

Item {
    id: aiAssistant
    width: parent.width
    height: parent.height /2
    anchors.centerIn: parent
    visible: false
    z: 1000

    // 创建NotesManager实例
    NotesManager {
        id: notesManager
    }

    property bool recording: false

    // 添加语音识别器
    SpeechRecognizer {
        id: speechRecognizer
        onTextChanged: {
            recognitionText.text = text
        }
    }

    // 添加一个全屏的 MouseArea 来处理点击空白区域
    Item {
        // 确保这个 Item 覆盖整个屏幕
        width: parent.parent.width
        height: parent.parent.height
        anchors.centerIn: undefined  // 重置居中
        anchors.top: parent.parent.top
        anchors.left: parent.parent.left
        z: -1  // 确保在 AI 助手界面下层

        MouseArea {
            anchors.fill: parent
            enabled: aiAssistant.visible  // 只在 AI 助手可见时启用
            onClicked: {
                if (recording) {
                    speechRecognizer.stopRecording()
                }
                aiAssistant.visible = false  // 隐藏界面
                root.showFullItem = false  // 显示底部栏
                console.log("点击空白区域，停止录音并返回桌面")
            }
        }
    }

    // 添加关闭时的处理
    onVisibleChanged: {
        if (!visible) {
            if (recording) {
                speechRecognizer.stopRecording()
            }
            root.showFullItem = false
        }
    }

    // 背景和阴影
    Rectangle {
        id: background
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1a1a" }
            GradientStop { position: 1.0; color: "#2d2d2d" }
        }
        opacity: 0.95
        radius: 10

        // Qt6 的新阴影实现
        Rectangle {
            id: shadowRect
            anchors.fill: parent
            anchors.margins: -8
            radius: parent.radius + 8
            color: "transparent"
            z: -1

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: "#80000000"
                opacity: 0.5
            }
        }

        // 防止点击穿透的 MouseArea
        MouseArea {
            anchors.fill: parent
            onClicked: mouse.accepted = true  // 阻止点击穿透到背景
        }
    }

    // 顶部标题栏
    Rectangle {
        id: header
        width: parent.width
        height: 60
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: recording ? "正在录音..." : "AI 语音助手"
            font.pixelSize: 24
            color: "white"
        }

        Icon {
            id: closeButton
            anchors {
                right: parent.right
                rightMargin: 20
                verticalCenter: parent.verticalCenter
            }
            icon.source: "qrc:/resources/app_icons/close.svg"
            width: 30
            height: 30
            onClicked: {
                if (recording) {
                    speechRecognizer.stopRecording()
                }
                aiAssistant.visible = false
                root.showFullItem = false
            }
        }
    }

    // 主要内容区域
    ColumnLayout {
        anchors {
            top: header.bottom
            bottom: bottomBar.top
            left: parent.left
            right: parent.right
            margins: 20
        }
        spacing: 20

        // 直接显示文字，不需要额外的背景容器
        Text {
            id: recognitionText
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "语音识别结果将显示在这里..."
            color: "#e0e0e0"
            font {
                pixelSize: 24
                family: "Microsoft YaHei"
                weight: Font.Light
            }
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight: 1.2
        }
    }

    // 底部工具栏
    Rectangle {
        id: bottomBar
        width: parent.width
        height: 80
        anchors.bottom: parent.bottom
        color: "#2d2d2d"
        radius: 10

        RowLayout {
            anchors {
                centerIn: parent
                margins: 10
            }
            spacing: 30

            ActionButton {
                text: "保存笔记"
                iconSource: "qrc:/resources/app_icons/save.svg"
                onClicked: {
                    console.log("保存笔记按钮被点击")

                    // 获取要保存的内容
                    var noteContent = ""
                    if (recognitionText.text && recognitionText.text !== "语音识别结果将显示在这里...") {
                        noteContent = recognitionText.text
                    } else {
                        console.log("没有有效的内容可保存")
                        toast.show("没有内容可保存")
                        return
                    }

                    // 创建新笔记
                    var currentTime = new Date()
                    var noteTitle = "AI笔记 - " + currentTime.toLocaleString(Qt.locale(), "MM-dd hh:mm")
                    var noteFileName = "ai_note_" + currentTime.getTime() + ".txt"

                    console.log("准备保存笔记:", noteFileName)
                    console.log("笔记内容:", noteContent)

                    try {
                        // 保存笔记文件
                        var saveResult = notesManager.saveNote(noteFileName, noteContent)
                        if (!saveResult) {
                            console.error("保存笔记文件失败")
                            toast.show("保存失败")
                            return
                        }

                        // 显示保存成功提示
                        toast.show("笔记已保存")
                        console.log("笔记保存成功")

                        // 如果Notes页面存在，刷新其列表
                        if (root.notes && root.notes.item) {
                            console.log("刷新Notes页面列表")
                            root.notes.item.refreshNotes()
                            // 可选：显示Notes页面
                            root.notes.visible = true
                            root.showFullItem = true
                            aiAssistant.visible = false
                        }
                    } catch (e) {
                        console.error("保存笔记时发生错误:", e)
                        toast.show("保存失败：" + e)
                    }
                }
            }

            // 录音控制按钮
            Rectangle {
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                radius: width/2
                color: recording ? "#ff4444" : "#444444"

                Image {
                    anchors.centerIn: parent
                    source: recording ? "qrc:/resources/app_icons/stop.svg" : "qrc:/resources/app_icons/mic.svg"
                    width: 30
                    height: 30
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (recording) {
                            speechRecognizer.stopRecording()
                        } else {
                            speechRecognizer.startRecording()
                        }
                    }
                }
            }

            ActionButton {
                text: "清空"
                iconSource: "qrc:/resources/app_icons/delete.svg"
                onClicked: {
                    recognitionText.text = "语音识别结果将显示在这里..."
                }
            }
        }
    }

    // Toast提示组件
    Rectangle {
        id: toast
        width: toastText.width + 40
        height: 40
        radius: 20
        color: "#99000000"
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100

        Text {
            id: toastText
            color: "white"
            font.pixelSize: 14
            anchors.centerIn: parent
        }

        Timer {
            id: toastTimer
            interval: 2000
            onTriggered: toast.visible = false
        }

        function show(message) {
            toastText.text = message
            toast.visible = true
            toastTimer.restart()
        }
    }

    Component.onCompleted: {
        console.log("AIAssistant component completed")
        console.log("Object name:", objectName)
        console.log("Parent:", parent ? parent.objectName || "unnamed parent" : "no parent")
        console.log("Visible:", visible)
        console.log("Size:", width, "x", height)
        console.log(parent.parent.width)
        console.log(parent.parent.height)
    }
    onRecordingChanged: {
        aiAssistant.recording = recording
        if(recording)
            speechRecognizer.startRecording()
        else
            speechRecognizer.stopRecording()
    }
} 
