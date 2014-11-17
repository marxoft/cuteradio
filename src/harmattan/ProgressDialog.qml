import QtQuick 1.1
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

QueryDialog {
    id: root

    function showProgress(info) {
        infoLabel.text = info;
        root.open();
    }

    rejectButtonText: qsTr("Cancel")
    content: Item {
        height: column.height
        anchors {
            left: parent.left
            right: parent.right
        }

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: UI.PADDING_DOUBLE

            Image {
                id: icon

                x: Math.floor((parent.width / 2) - (width / 2))
                source: "images/info.png"
            }

            Label {
                id: infoLabel

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: UI.COLOR_INVERTED_FOREGROUND
            }
        }
    }
}
