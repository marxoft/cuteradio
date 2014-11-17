import QtQuick 1.1
import com.nokia.meego 1.0

ToolButton {
    id: button

    platformStyle: ToolButtonStyle {
        textColor: Settings.activeColor
    }
    width: 300
    anchors.centerIn: parent
    iconSource: "images/" + (player.playing ? "play" : "stop") + "-accent-" + Settings.activeColorString + ".png"
    text: player.metaData.title ? player.metaData.title : player.currentStation.title
    visible: player.currentStation.id != ""
    onClicked: appWindow.pageStack.push(Qt.resolvedUrl("NowPlayingPage.qml"))
}
