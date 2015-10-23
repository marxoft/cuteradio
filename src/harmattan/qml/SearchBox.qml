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
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

Item {
    id: root

    height: 72

    property alias searchText: textField.text
    property alias placeholderText: textField.placeholderText
    property string __invertedString: theme.inverted ? "-inverted" : ""
    property string __screenOrientation: appWindow.inPortrait ? "portrait" : "landscape"

    signal accepted

    function platformCloseSoftwareInputPanel() {
        textField.platformCloseSoftwareInputPanel();
    }

    Image {
        anchors.fill: parent
        source: "image://theme/meegotouch-tab-" + __screenOrientation + "-bottom" + __invertedString + "-background"
        fillMode: Image.Stretch
    }

    MyTextField {
        id: textField

        anchors {
            left: parent.left
            leftMargin: UI.PADDING_DOUBLE
            right: parent.right
            rightMargin: UI.PADDING_DOUBLE
            verticalCenter: parent.verticalCenter
        }
        rightMargin: 55
        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
        actionLabel: qsTr("Search")
        onAccepted: root.accepted()
    }

    Image {
        id: icon

        z: 1000
        anchors {
            right: textField.right
            rightMargin: UI.PADDING_DOUBLE
            verticalCenter: textField.verticalCenter
        }
        source: "image://theme/icon-m-input-clear"
        opacity: mouseArea.pressed ? 0.5 : 1
        visible: textField.text != ""

        MouseArea {
            id: mouseArea

            width: 60
            height: 60
            anchors.centerIn: parent
            onClicked: {
                textField.text = "";
                textField.platformCloseSoftwareInputPanel();
            }
        }
    }

    onAccepted: {
        focus = false;
        textField.platformCloseSoftwareInputPanel();
    }
}
