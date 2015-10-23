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

MySheet {
    id: root

    acceptButtonText: sourceField.text ? qsTr("Done") : ""
    rejectButtonText: qsTr("Cancel")
    content: Item {
        anchors.fill: parent
        clip: true

        Flickable {
            id: flicker

            anchors {
                fill: parent
                margins: UI.PADDING_DOUBLE
            }
            contentHeight: column.height + UI.PADDING_DOUBLE

            Column {
                id: column

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: UI.PADDING_DOUBLE

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Source")
                }

                MyTextField {
                    id: sourceField

                    width: parent.width
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
                    onAccepted: root.accept()
                }
            }
        }

        ScrollDecorator {
            flickableItem: flicker
        }
    }

    onAccepted: {
        var station = {
	    "id": "url",
            "title": qsTr("Unknown"),
            "description": "",
            "genre": qsTr("Unknown"),
            "country": qsTr("Unknown"),
            "language": qsTr("Unknown"),
            "logo": "",
            "source": sourceField.text
        };
        
        player.playStation(station);
    }
    
    onStatusChanged: {
        if (status === DialogStatus.Opening) {
            sourceField.text = "";
            sourceField.forceActiveFocus();
        }
    }
}
