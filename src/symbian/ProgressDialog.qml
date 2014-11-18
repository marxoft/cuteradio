import QtQuick 1.1
import com.nokia.symbian 1.1

QueryDialog {
    id: root

    function showProgress(info) {
        titleText = qsTr("Please wait");
        icon = "images/info.png";
        rejectButtonText = qsTr("Cancel");
        infoLabel.text = info;
        root.open();
    }
    
    function showMessage(info) {
        titleText = qsTr("Info");
        icon = "images/info.png";
        rejectButtonText = qsTr("Close");
        infoLabel.text = info;
        root.open();
    }
    
    function showError(info) {
        titleText = qsTr("Error");
        icon = "images/error.png";
        rejectButtonText = qsTr("Close");
        infoLabel.text = info;
        root.open();
    }

    height: contentItem.height + 140
    platformInverted: false
    rejectButtonText: qsTr("Cancel")
    titleText: qsTr("Please wait")
    icon: "images/info.png"
    content: Item {
        id: contentItem

        height: infoLabel.height
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: platformStyle.paddingLarge
        }

        Label {
            id: infoLabel

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            wrapMode: Text.Wrap
        }
    }
}
