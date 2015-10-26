/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
