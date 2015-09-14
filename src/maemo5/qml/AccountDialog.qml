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
import CuteRadio 1.0 as CuteRadio

Dialog {
    id: root
    
    height: column.height + platformStyle.paddingMedium
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
        }
        
        Label {
            width: parent.width
            text: qsTr("Password")
        }
        
        TextField {
            id: passwordField
            
            width: parent.width
            echoMode: TextInput.Password
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
        enabled: (usernameField.text) && (passwordField.text)
        onClicked: request.insert({username: usernameField.text, password: passwordField.text}, "/token")
    }
    
    CuteRadio.ResourcesRequest {
        id: request
        
        onStatusChanged: {
            switch (status) {
            case CuteRadio.ResourcesRequest.Loading: {
                root.showProgressIndicator = true;
                column.enabled = false;
                return;
            }
            case CuteRadio.ResourcesRequest.Ready: {
                if (result.token) {
                    Settings.token = result.token;
                    Settings.userId = result.id;
                    informationBox.information(qsTr("You are signed in to cuteRadio"));
                    root.accept();
                }
                else {
                    informationBox.information(qsTr("Cannot obtain access token"));
                }
                
                break;
            }
            case CuteRadio.ResourcesRequest.Error:
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
                height: column.height + acceptButton.height + platformStyle.paddingMedium * 2
            }
        
            AnchorChanges {
                target: column
                anchors {
                    right: parent.right
                    bottom: acceptButton.top
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
            usernameField.forceActiveFocus();
        }
    }
}
