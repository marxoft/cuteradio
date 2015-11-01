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
import com.nokia.symbian 1.1
import CuteRadio 1.0 as CuteRadio

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
    hideHeaderWhenInputContextIsVisible: true
    acceptButtonText: (titleField.text) && (sourceField.text) ? qsTr("Done") : ""
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
                    text: qsTr("Title")
                    visible: titleField.visible
                }

                MyTextField {
                    id: titleField

                    width: parent.width
                    visible: (!inputContext.visible) || (focus)
                    onAccepted: descriptionField.forceActiveFocus()
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Description")
                    visible: descriptionField.visible
                }

                TextArea {
                    id: descriptionField

                    width: parent.width
                    visible: (!inputContext.visible) || (focus)
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Genre")
                    visible: genreField.visible
                }

                MyTextField {
                    id: genreField

                    width: parent.width
                    visible: (!inputContext.visible) || (focus)
                    onAccepted: countryField.forceActiveFocus()
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Country")
                    visible: countryField.visible
                }

                MyTextField {
                    id: countryField

                    width: parent.width
                    visible: (!inputContext.visible) || (focus)
                    onAccepted: languageField.forceActiveFocus()
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Language")
                    visible: languageField.visible
                }

                MyTextField {
                    id: languageField

                    width: parent.width
                    visible: (!inputContext.visible) || (focus)
                    onAccepted: sourceField.forceActiveFocus()
                }

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
                    onAccepted: closeSoftwareInputPanel()
                }
            }
        }

        MyScrollBar {
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
            case CuteRadio.ResourcesRequest.Ready: {
                infoBanner.showMessage(root.stationId ? qsTr("Station updated") : qsTr("Station added"));
                root.accept();
                break;
            }
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
