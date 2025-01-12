import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Style

RowLayout {
    spacing: 12
    property real temp: 72
    anchors.right: parent.right
    property bool airbagOn: false
    property string currentTime: "12:00"

    Text {
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        text: currentTime
        font.family: "Inter"
        font.pixelSize: 23
        font.bold: Font.DemiBold
        color: Style.black20
    }

    Text {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        text: "%0℃".arg(temp)
        font.family: "Inter"
        font.pixelSize: 23
        font.bold: Font.DemiBold
        color: Style.black20
    }

    Timer {
        id: hourlyTimer
        interval: 3600000 // 1小时 = 3600秒 = 3600000毫秒
        repeat: true
        running: true
        onTriggered: loadWeather()
    }

    Timer {
        id: timeTimer
        interval: 1000  // 每秒更新一次
        repeat: true
        running: true
        onTriggered: updateCurrentTime()
    }

    function loadWeather() {
        var request = new XMLHttpRequest();
        var url = "http://gfeljm.tianqiapi.com/api?unescape=1&version=v61&appid=33178861&appsecret=u1OWkwtY";

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {

                if (request.status === 200) {
                    var response = JSON.parse(request.responseText);
                    temp = parseFloat(response.tem); // 假设 tem 是当前温度字段

                } else {
                    temp = 0;
                    console.log("温度获取失败！！！")
                }
            }
        }
        request.open("GET", url);
        request.send();
    }

    function updateCurrentTime() {
        var date = new Date();
        currentTime = Qt.formatTime(date, "HH:mm");
    }

    Component.onCompleted: {
        updateCurrentTime()  // 初始化时立即更新一次时间
        loadWeather()
    }
}

// Control {
//     Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
//     implicitHeight: 38
//     id: controlID
//     background: Rectangle {
//         color: Style.black20
//         radius: 7
//     }
//     contentItem: RowLayout {
//         spacing: 10
//         anchors.centerIn: parent
//         Image {
//             Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
//             Layout.leftMargin: 10
//             source: "qrc:/resources/top_header_icons/airbag_.svg"
//         }
//         Text {
//             Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
//             Layout.rightMargin: 10
//             text: airbagOn ? "PASSENGER\nAIRBAG ON" : "PASSENGER\nAIRBAG OFF"
//             font.family: Style.fontFamily
//             font.bold: Font.Bold
//             font.pixelSize: 12
//             color: Style.white
//         }
//     }
// }




