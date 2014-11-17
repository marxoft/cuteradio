/*
 * Copyright (C) 2014 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU Lesser General Public License,
 * version 3, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

MySheet {
    id: root

    hideHeaderWhenInputContextIsVisible: true
    acceptButtonText: sourceField.acceptableInput ? qsTr("Done") : ""
    rejectButtonText: qsTr("Cancel")
    content: Item {
        anchors.fill: parent

        KeyNavFlickable {
            id: flicker

            anchors {
                fill: parent
                margins: platformStyle.paddingLarge
            }
            contentHeight: inputContext.visible ? height : column.height + platformStyle.paddingLarge

            Column {
                id: column

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                spacing: platformStyle.paddingLarge

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Source")
                    visible: sourceField.visible
                }

                MyTextField {
                    id: sourceField

                    width: parent.width
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
                    visible: (!inputContext.visible) || (focus)
                    validator: RegExpValidator {
                        regExp: /^.+/
                    }
                    onAccepted: root.accept()
                }
            }
        }

        MyScrollBar {
            flickableItem: flicker
        }
    }

    onAccepted: {
        var station = {
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
            sourceField.focus = true;
        }
    }
}
