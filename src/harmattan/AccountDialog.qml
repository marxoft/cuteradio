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
import com.nokia.meego 1.0
import org.marxoft.cuteradio 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

MySheet {
    id: root

    acceptWhenDone: false
    acceptButtonText: (usernameField.acceptableInput) && (passwordField.acceptableInput) ? qsTr("Done") : ""
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
                    validator: RegExpValidator {
                        regExp: /^[\w\-_]{6,}/
                    }
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
                    validator: RegExpValidator {
                        regExp: /^[\w\-_]{6,}/
                    }
                    onAccepted: platformCloseSoftwareInputPanel()
                }
            }
        }

        ScrollDecorator {
            flickableItem: flicker
        }
    }
    
    CuteRadioRequest {
        id: request
        
        url: TOKEN_URL
        data: { "username": usernameField.text, "password": passwordField.text }
        authRequired: false
        onStatusChanged: {
            switch (status) {
            case CuteRadioRequest.Loading: {
                progressDialog.showProgress(qsTr("Signing in"));
                column.enabled = false;
                return;
            }
            case CuteRadioRequest.Ready: {
                if (result.token) {
                    Settings.token = result.token;
                    infoBanner.showMessage(qsTr("You are signed in to cuteRadio"));
                    root.accept();
                }
                else {
                    infoBanner.showMessage(qsTr("Cannot obtain access token"));
                }
                
                break;
            }
            case CuteRadioRequest.Error:
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

    onDone: request.post()
    onRejected: request.cancel()
    onStatusChanged: {
        if (status === DialogStatus.Opening) {
            usernameField.text = "";
            passwordField.text = "";
            usernameField.focus = true;
        }
    }
}
