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
import org.marxoft.cuteradio 1.0

Dialog {
    id: root
    
    property string stationId
    property string logo
    property alias title: titleField.text
    property alias description: descriptionField.text
    property alias genre: genreField.text
    property alias country: countryField.text
    property alias language: languageField.text
    property alias source: sourceField.text
    property alias result: request.result
    
    height: 360
    title: qsTr("Add station")
    
    Flickable {
        id: flicker
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMargin
            top: parent.top
            bottom: parent.bottom
        }
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        contentHeight: column.height
        
        Column {
            id: column
            
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            
            Label {
                width: parent.width
                text: qsTr("Title")
            }
            
            TextField {
                id: titleField
                
                width: parent.width
                validator: RegExpValidator {
                    regExp: /^.+/
                }
            }
            
            Label {
                width: parent.width
                text: qsTr("Description")
            }
            
            TextField {
                width: parent.width
                id: descriptionField
            }
            
            Label {
                width: parent.width
                text: qsTr("Genre")
            }
            
            TextField {
                id: genreField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Country")
            }
            
            TextField {
                id: countryField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Language")
            }
            
            TextField {
                id: languageField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Source")
            }
            
            TextField {
                id: sourceField
                
                width: parent.width
                validator: RegExpValidator {
                    regExp: /^.+/
                }
            }
        }
    }
    
    Button {
        id: acceptButton
        
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        style: DialogButtonStyle {}
        text: qsTr("Done")
        enabled: (titleField.acceptableInput) && (sourceField.acceptableInput)
        onClicked: {
            var station = {};
            station["title"] = titleField.text;
            station["source"] = sourceField.text;

            if (logo) {
                station["logo"] = logo;
            }
            
            if (descriptionField.text) {
                station["description"] = descriptionField.text;
            }
            
            if (genreField.text) {
                station["genre"] = genreField.text;
            }
            
            if (countryField.text) {
                station["country"] = countryField.text;
            }
            
            if (languageField.text) {
                station["language"] = languageField.text;
            }

            request.data = station;

            if (stationId) {
                request.url = MY_STATIONS_URL + "/" + stationId;
                request.put();
            }
            else {
                request.url = MY_STATIONS_URL;
                request.post();
            }
        }
    }
    
    CuteRadioRequest {
        id: request
        
        url: MY_STATIONS_URL
        authRequired: true
        onStatusChanged: {
            switch (status) {
            case CuteRadioRequest.Loading: {
                root.showProgressIndicator = true;
                column.enabled = false;
                return;
            }
            case CuteRadioRequest.Ready:
                root.accept();
                break;
            case CuteRadioRequest.Error:
                infobox.showError(errorString);
                break;
            default:
                break;
            }
            
            root.showProgressIndicator = false;
            column.enabled = true;
        }
    }
    
    StateGroup {
        states: State {
            name: "Portrait"
            when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation
        
            PropertyChanges {
                target: root
                height: 680
            }
        
            AnchorChanges {
                target: flicker
                anchors {
                    right: parent.right
                    bottom: button.top
                }
            }
        
            PropertyChanges {
                target: flicker
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
    
    onRejected: request.cancel()
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            titleField.clear();
            descriptionField.clear();
            genreField.clear();
            countryField.clear();
            languageField.clear();
            sourceField.clear();
            titleField.focus = true;
        }
    }
}
