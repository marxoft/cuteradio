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
import Ubuntu.Components.ListItems 1.0
import org.marxoft.cuteradio 1.0

Page {
	id: root
	
	title: i18n.tr("Account")
	
	Flickable {
		id: flicker
		
		anchors.fill: parent
		contentHeight: column.height
		
		Column {
			id: column
			
			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
				margins: units.gu(1)
			}
			spacing: units.gu(1)
			
			Label {
				width: parent.width
				wrapMode: Text.WordWrap
				horizontalAlignment: Text.AlignHCenter
				text: i18n.tr("Please enter a username and password to create a cuteRadio account.")
			}
			
			ThinDivider {}
		
			Label {
				width: parent.width
				text: i18n.tr("Username")
			}
		
			TextField {
				id: usernameField
				
				width: parent.width
				inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
				validator: RegExpValidator {
                        regExp: /^[\w\-_]{6,}/
				}
				onAccepted: passwordField.forceActiveFocus()
			}
		
			Label {
				width: parent.width
				text: i18n.tr("Password")
			}
		
			TextField {
				id: passwordField
				
				width: parent.width
				echoMode: TextInput.Password
				inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
				validator: RegExpValidator {
					regExp: /^[\w\-_]{6,}/
				}
			}
			
			Button {
				x: Math.floor((column.width - width) / 2)
				text: qsTr("Sign in")
				color: UbuntuColors.green
				enabled: (usernameField.acceptableInput) && (passwordField.acceptableInput)
				onClicked: request.post()
			}
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
                progressDialog.showProgress(i18n.tr("Signing in"));
                column.enabled = false;
                return;
            }
            case CuteRadioRequest.Ready: {
                if (result.token) {
                    Settings.token = result.token;
                    infoBanner.showMessage(i18n.tr("You are signed in to cuteRadio"));
                    pageStack.pop();
                }
                else {
                    infoBanner.showMessage(i18n.tr("Cannot obtain access token"));
                }
                
                break;
            }
            case CuteRadioRequest.Error:
                infoBanner.showMessage(errorString);
                break;
            default:
                break;
            }
            
            progressDialog.hide();
            column.enabled = true;
        }
    }

    Connections {
        target: progressDialog
        onRejected: request.cancel()
    }
}
