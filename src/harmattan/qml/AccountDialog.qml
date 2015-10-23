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

    acceptWhenDone: false
    acceptButtonText: (usernameField.text) && (passwordField.text) ? qsTr("Done") : ""
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
                    text: qsTr("Username")
                }

                MyTextField {
                    id: usernameField

                    width: parent.width
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                    actionLabel: qsTr("Next")
                    onAccepted: passwordField.forceActiveFocus()
                }

                Label {
                    width: parent.width
                    elide: Text.ElideRight
                    font.bold: true
                    text: qsTr("Password")
                }

                MyTextField {
                    id: passwordField

                    width: parent.width
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
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

        onStatusChanged: {
            switch (status) {
            case CuteRadio.ResourcesRequest.Loading: {
                progressDialog.showProgress(qsTr("Signing in"));
                column.enabled = false;
                return;
            }
            case CuteRadio.ResourcesRequest.Ready: {
                if (result.token) {
                    Settings.token = result.token;
                    Settings.userId = result.id;
                    infoBanner.showMessage(qsTr("You are signed in to cuteRadio"));
                    root.accept();
                }
                else {
                    infoBanner.showMessage(qsTr("Cannot obtain access token"));
                }
                
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

    onDone: request.insert({username: usernameField.text, password: passwordField.text}, "/token")
    onRejected: request.cancel()
    onStatusChanged: {
        if (status === DialogStatus.Opening) {
            usernameField.text = "";
            passwordField.text = "";
            usernameField.forceActiveFocus();
        }
    }
}
