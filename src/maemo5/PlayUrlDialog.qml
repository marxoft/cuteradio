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
 
import org.hildon.components 1.0

Dialog {
    id: root
    
    height: window.inPortrait ? 160 : 80
    windowTitle: qsTr("Play URL")
    content: TextField {
        id: urlField
        
        anchors.fill: parent
        placeholderText: qsTr("URL")
        validator: RegExpValidator {
            regExp: /^.+/
        }
        onReturnPressed: root.accept()
    }
    
    buttons: Button {
        focusPolicy: Qt.NoFocus
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
            "logo": "",
            "source": urlField.text
        };
        
        player.playStation(station);
    }
    
    onVisibleChanged: {
        if (visible) {
            urlField.clear();
            urlField.focus = true;
        }
    }
}
