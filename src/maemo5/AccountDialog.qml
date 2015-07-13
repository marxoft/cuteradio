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
    
    height: 240
    title: qsTr("cuteRadio account")
    
    Column {
        id: column
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMedium
            bottom: parent.bottom
        }
        spacing: platformStyle.paddingMedium
        
        Label {
            width: parent.width
            text: qsTr("Username")
        }
        
        TextField {
            id: usernameField
            
            width: parent.width
            validator: RegExpValidator {
                regExp: /^[\w\-_]{6,}/
            }
        }
        
        Label {
            width: parent.width
            text: qsTr("Password")
        }
        
        TextField {
            id: passwordField
            
            width: parent.width
            validator: RegExpValidator {
                regExp: /^[\w\-_]{6,}/
            }
            echoMode: TextField.Password
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
        enabled: (usernameField.acceptableInput) && (passwordField.acceptableInput)
        onClicked: request.post()
    }
    
    CuteRadioRequest {
        id: request
        
        url: TOKEN_URL
        data: { "username": usernameField.text, "password": passwordField.text }
        authRequired: false
        onStatusChanged: {
            switch (status) {
            case CuteRadioRequest.Loading: {
                root.showProgressIndicator = true;
                column.enabled = false;
                return;
            }
            case CuteRadioRequest.Ready: {
                if (result.token) {
                    Settings.token = result.token;
                    informationBox.information(qsTr("You are signed in to cuteRadio"));
                    root.accept();
                }
                else {
                    informationBox.information(qsTr("Cannot obtain access token"));
                }
                
                break;
            }
            case CuteRadioRequest.Error:
                informationBox.information(errorString);
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
                height: 320
            }
        
            AnchorChanges {
                target: column
                anchors {
                    right: parent.right
                    bottom: button.top
                }
            }
        
            PropertyChanges {
                target: column
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
            usernameField.clear();
            passwordField.clear();
            usernameField.focus = true;
        }
    }
}
