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

import QtQuick 1.0
import org.hildon.components 1.0

Dialog {
    id: root
    
    height: urlField.height + platformStyle.paddingMedium
    title: qsTr("Play URL")
    
    TextField {
        id: urlField
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMedium
            bottom: parent.bottom
        }
        placeholderText: qsTr("URL")
        validator: RegExpValidator {
            regExp: /^.+/
        }
        onAccepted: root.accept()
    }
    
    Button {
        id: acceptButton
        
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        style: DialogButtonStyle {}
        text: qsTr("Done")
        enabled: urlField.acceptableInput
        onClicked: root.accept()
    }
    
    onAccepted: {
        var station = {
            "id": "url",
            "title": qsTr("(unknown station)"),
            "description": "",
            "genre": qsTr("(unknown genre)"),
            "country": qsTr("(unknown country)"),
            "language": qsTr("(unknown language)"),
            "source": urlField.text
        };
        
        player.playStation(station);
    }
    
    StateGroup {
        states: State {
            name: "Portrait"
            when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation
        
            PropertyChanges {
                target: root
                height: urlField.height + acceptButton.height + platformStyle.paddingMedium * 2
            }
        
            AnchorChanges {
                target: urlField
                anchors {
                    right: parent.right
                    bottom: acceptButton.top
                }
            }
        
            PropertyChanges {
                target: urlField
                anchors {
                    rightMargin: 0
                    bottomMargin: platformStyle.paddingMedium
                }
            }
        
            PropertyChanges {
                target: acceptButton
                width: parent.width
            }
        }
    }
    
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            urlField.clear();
            urlField.forceActiveFocus();
        }
    }
}
