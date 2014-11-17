import QtQuick 1.1
import com.nokia.symbian 1.1

ToolButton {
    id: root

    anchors.centerIn: parent
    flat: false
    iconSource: "images/" + (player.playing ? "play" : "stop") + "-accent-" + Settings.activeColorString + ".png"
    text: player.metaData.title ? player.metaData.title : player.currentStation.title
    visible: player.currentStation.id != ""
    onClicked: appWindow.pageStack.push(Qt.resolvedUrl("NowPlayingPage.qml"))
    onTextChanged: internal.resetButton()
    onVisibleChanged: internal.resetButton()
    onWidthChanged: if (width != 240) internal.resetButton();
    Component.onCompleted: internal.resetButton()

    QtObject {
        id: internal

        function resetButton() {
            root.width = 240;
        }
    }
}
