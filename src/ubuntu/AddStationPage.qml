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
import org.marxoft.cuteradio 1.0

Page {
    id: root
    
    property variant station: {
        "id": "",
        "title": "",
        "description": "",
        "genre": "",
        "country": "",
        "language": "",
        "logo": "",
        "source": "",
        "is_favourite": false,
        "favourite_id": "",
        "last_played": ""
    }
    
    property string mode: "add" // Can also be "edit"
    property alias result: request.result
    
    title: station.id ? i18n.tr("Edit station") : i18n.tr("New station")
    head.actions: Action {
        iconName: "ok"
        text: i18n.tr("Ok")
        enabled: (titleField.acceptableInput) && (sourceField.acceptableInput)
        onTriggered: {
            var newStation = {};
            newStation["title"] = titleField.text;
            newStation["source"] = sourceField.text;

            if (station.logo) {
                newStation["logo"] = station.logo;
            }
        
            if (descriptionField.text) {
                newStation["description"] = descriptionField.text;
            }
        
            if (genreField.text) {
                newStation["genre"] = genreField.text;
            }
        
            if (countryField.text) {
                newStation["country"] = countryField.text;
            }
        
            if (languageField.text) {
                newStation["language"] = languageField.text;
            }

            request.data = newStation;

            if (mode == "edit") {
                request.url = MY_STATIONS_URL + "/" + station.id;
                request.put();
            }
            else {
                request.url = MY_STATIONS_URL;
                request.post();
            }
        }
    }
    
    Flickable {
        id: flicker

        anchors.fill: parent
        contentHeight: column.height + units.gu(1)

        Column {
            id: column

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(1)
            }
            spacing: units.gu(1)

            Label {
                width: parent.width
                elide: Text.ElideRight
                text: i18n.tr("Title")
            }

            TextField {
                id: titleField

                width: parent.width
                validator: RegExpValidator {
                    regExp: /^.+/
                }
                text: station.title
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                text: i18n.tr("Description")
            }

            TextArea {
                id: descriptionField

                width: parent.width
                text: station.description
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                text: i18n.tr("Genre")
            }

            TextField {
                id: genreField

                width: parent.width
                text: station.genre
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                text: i18n.tr("Country")
            }

            TextField {
                id: countryField

                width: parent.width
                text: station.country
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                text: i18n.tr("Language")
            }

            TextField {
                id: languageField

                width: parent.width
                text: station.language
            }

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
                text: station.source
            }
        }
    }

    Scrollbar {
        flickableItem: flicker
    }
    
    CuteRadioRequest {
        id: request
        
        url: MY_STATIONS_URL
        authRequired: true
        onStatusChanged: {
            switch (status) {
            case CuteRadioRequest.Loading:
                progressDialog.showProgress(root.mode == "edit" ? i18n.tr("Updating station")
                                                                : i18n.tr("Adding station"));
                return;
            case CuteRadioRequest.Error:
                infoBanner.showMessage(errorString);
                break;
            default:
                break;
            }
            
            progressDialog.hide();
            pageStack.pop();
        }
    }

    Connections {
        target: progressDialog
        onRejected: request.cancel()
    }    
}
