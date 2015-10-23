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
import CuteRadio 1.0 as CuteRadio
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

MySheet {
    id: root
    
    property string stationId
    property alias title: titleField.text
    property alias description: descriptionField.text
    property alias genre: genreField.text
    property alias country: countryField.text
    property alias language: languageField.text
    property alias source: sourceField.text
    property alias result: request.result

    acceptWhenDone: false
    acceptButtonText: (titleField.text) && (sourceField.text) ? qsTr("Done") : ""
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
                    text: qsTr("Title")
                }

                MyTextField {
                    id: titleField

                    width: parent.width
                    actionLabel: qsTr("Next")
                    onAccepted: descriptionField.forceActiveFocus()
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Description")
                }

                MyTextArea {
                    id: descriptionField

                    width: parent.width
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Genre")
                }

                MyTextField {
                    id: genreField

                    width: parent.width
                    actionLabel: qsTr("Next")
                    onAccepted: countryField.forceActiveFocus()
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Country")
                }

                MyTextField {
                    id: countryField

                    width: parent.width
                    actionLabel: qsTr("Next")
                    onAccepted: languageField.forceActiveFocus()
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Language")
                }

                MyTextField {
                    id: languageField

                    width: parent.width
                    actionLabel: qsTr("Next")
                    onAccepted: sourceField.forceActiveFocus()
                }

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
                    onAccepted: platformCloseSoftwareInputPanel()
                }
            }
        }

        ScrollDecorator {
            flickableItem: flicker
        }
    }
    
    CuteRadio.ResourcesRequest {
        id: request
        
        accessToken: Settings.token
        onStatusChanged: {
            switch (status) {
            case CuteRadio.ResourcesRequest.Loading: {
                progressDialog.showProgress(root.stationId ? qsTr("Updating station") : qsTr("Adding station"));
                column.enabled = false;
                return;
            }
            case CuteRadio.ResourcesRequest.Ready:
                root.accept();
                break;
            case CuteRadio.ResourcesRequest.Error:
                infoBanner.showMessage(errorString);
                break;
            default:
                break;
            }
            
            progressDialog.close();
            column.enabled = true;
        }
    }

    Connections {
        target: progressDialog
        onRejected: request.cancel()
    }

    onDone: {
        var station = {};
        station["title"] = titleField.text;
        station["source"] = sourceField.text;
        
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

        if (stationId) {
            request.update("/stations/" + stationId, station);
        }
        else {
            request.insert(station, "/stations");
        }
    }
    onRejected: request.cancel()
    onStatusChanged: {
        if (status === DialogStatus.Opening) {
            titleField.text = "";
            descriptionField.text = "";
            genreField.text = "";
            countryField.text = "";
            languageField.text = "";
            sourceField.text = "";
            titleField.forceActiveFocus();
        }
    }
}
