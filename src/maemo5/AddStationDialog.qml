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
    
    height: window.inPortrait ? 680 : 360
    windowTitle: qsTr("Add station")
    content: Flickable {
        id: flicker
        
        anchors.fill: parent
        
        Column {
            id: column
            
            Label {
                text: qsTr("Title")
            }
            
            TextField {
                id: titleField
                
                validator: RegExpValidator {
                    regExp: /^.+/
                }
            }
            
            Label {
                text: qsTr("Description")
            }
            
            TextField {
                id: descriptionField
            }
            
            Label {
                text: qsTr("Genre")
            }
            
            TextField {
                id: genreField
            }
            
            Label {
                text: qsTr("Country")
            }
            
            TextField {
                id: countryField
            }
            
            Label {
                text: qsTr("Language")
            }
            
            TextField {
                id: languageField
            }
            
            Label {
                text: qsTr("Source")
            }
            
            TextField {
                id: sourceField
                
                validator: RegExpValidator {
                    regExp: /^.+/
                }
            }
        }
    }
    
    buttons: Button {
        focusPolicy: Qt.NoFocus
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
    
    onRejected: request.cancel()
    onVisibleChanged: {
        if (visible) {
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
