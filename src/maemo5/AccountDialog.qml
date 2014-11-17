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
    
    height: window.inPortrait ? 320 : 240
    windowTitle: qsTr("cuteRadio account")
    content: Column {
        id: column
        
        anchors.fill: parent
        
        Label {
            text: qsTr("Username")
        }
        
        TextField {
            id: usernameField
            
            validator: RegExpValidator {
                regExp: /^[\w\-_]{6,}/
            }
        }
        
        Label {
            text: qsTr("Password")
        }
        
        TextField {
            id: passwordField
            
            validator: RegExpValidator {
                regExp: /^[\w\-_]{6,}/
            }
            echoMode: TextField.Password
        }
    }
    
    buttons: Button {
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
                    infobox.showMessage(qsTr("You are signed in to cuteRadio"));
                    root.accept();
                }
                else {
                    infobox.showError(qsTr("Cannot obtain access token"));
                }
                
                break;
            }
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
            usernameField.clear();
            passwordField.clear();
            usernameField.focus = true;
        }
    }
}
