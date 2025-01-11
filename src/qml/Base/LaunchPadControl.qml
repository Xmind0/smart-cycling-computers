import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Style
import Qt5Compat.GraphicalEffects

Popup {
    width: 730
    height: 400
    background: Rectangle {
        anchors.fill: parent
        radius: 9
        color: Style.alphaColor(Style.black,0.8)
    }

    contentItem: ColumnLayout {
        spacing: 8
        anchors.fill: parent
        RowLayout {
            Layout.leftMargin: 16
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            spacing: 16
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/wiper.svg"
                icon.width: 12
                icon.height: 12
                text: "Wipers"
            }
        }

        Rectangle {
            // Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            width: parent.width
            height: 1
            color: Style.black30
        }

        RowLayout {
            Layout.leftMargin: 10
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            spacing: 2
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/blue-wifi.svg"
                icon.width: 12
                icon.height: 12
                text: "Dashcam"
            }
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/wyy.svg"
                icon.width: 12
                icon.height: 12
                text: "Theater"
            }
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/dashcam.svg"
                icon.width: 12
                icon.height: 12
                text: "Spotify"
            }
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/video.svg"
                icon.width: 12
                icon.height: 12
                text: "Spotify"
            }
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/navi.svg"
                icon.width: 12
                icon.height: 12
                text: "Spotify"
            }
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/spotify.svg"
                icon.width: 12
                icon.height: 12
                text: "Spotify"
            }
             LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/spotify.svg"
                icon.width: 12
                icon.height: 12
                text: "Spotify"
            }
        }

        RowLayout {
            Layout.leftMargin: 10
            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
            spacing: 2
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/caraoke.svg"
                icon.width: 12
                icon.height: 12
                text: "Caraoke"
            }
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/tunein.svg"
                icon.width: 12
                icon.height: 12
                text: "TuneIn"
            }
            LauncherButton {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                icon.source: "qrc:/resources/app_icons/radio.svg"
                icon.width: 12
                icon.height: 12
                text: "Music"
            }
        }
    }
}
