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
import org.marxoft.cuteradio 1.0

Item {
    id: root
    
    anchors.fill: parent
    
    Grid {
        id: grid
        
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 10
        }
        
        columns: 2
        spacing: 10
        
        Label {
            width: 120
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Username:"
        }
        
        TextField {
            id: usernameField
            
            width: parent.width - 130
            height: 30
        }
        
        Label {
            width: 120
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Password:"
        }
        
        TextField {
            id: passwordField
            
            width: parent.width - 130
            height: 30
        }
    }
    
    Column {
        anchors {
            left: grid.left
            right: grid.right
            top: grid.bottom
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        spacing: 10
    
        Button {
            width: parent.width
            text: Settings.token ? "Delete token" : "Get token"
            enabled: (Settings.token) || ((usernameField.text) && (passwordField.text))
            onClicked: Settings.token ? request.deleteResource() : request.post()
        }
        
        Label {
            width: parent.width
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Credentials:"
        }
        
        TextArea {
            id: resultArea
            
            width: parent.width
            height: parent.height - 80
            text: "Token: " + Settings.token
        }
    }
    
    CuteRadioRequest {
        id: request
        
        url: TOKEN_URL
        data: { "username": usernameField.text, "password": passwordField.text }
        authRequired: Settings.token ? true : false
        onStatusChanged: {
            if (status == CuteRadioRequest.Ready) {
                resultArea.text = "";
                
                for (var att in result) {
                    resultArea.text += (att + ": " + result[att] + "\n");
                }
                
                if (result.token) {
                    Settings.token = result.token;
                }
                else {
                    Settings.token = "";
                }
            }
        }
    }
}
