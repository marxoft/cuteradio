/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
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

import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0

Dialog {
    id: root
    
    title: i18n.tr("Play URL")

    contents: Column {
        width: parent.width
        spacing: units.gu(1)

        Label {
            width: parent.width
            elide: Text.ElideRight
            text: i18n.tr("Source")
        }

        TextField {
            id: sourceField

            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly | Qt.ImhNoPredictiveText
            validator: RegExpValidator {
                regExp: /^.+/
            }
            onAccepted: acceptButton.clicked()
        }
    }
    
    Button {
        id: cancelButton
        
        text: i18n.tr("Cancel")
        iconName: "cancel"
        color: UbuntuColors.red
        onClicked: PopupUtils.close(root);
    }
    
    Button {
        id: acceptButton
        
        text: i18n.tr("Done")
        iconName: "ok"
        color: UbuntuColors.green
        enabled: sourceField.acceptableInput
        onClicked: {
            var station = {
                "id": "url",
                "title": i18n.tr("Unknown"),
                "description": "",
                "genre": i18n.tr("Unknown"),
                "country": i18n.tr("Unknown"),
                "language": i18n.tr("Unknown"),
                "logo": "",
                "source": sourceField.text
            };
        
            player.playStation(station);
            PopupUtils.close(root);
        }
    }
}
