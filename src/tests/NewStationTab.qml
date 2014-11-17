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
            text: "Title:"
        }
        
        TextField {
            id: titleField
            
            width: parent.width - 130
            height: 30
        }
        
        Label {
            width: 120
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Genre:"
        }
        
        TextField {
            id: genreField
            
            width: parent.width - 130
            height: 30
        }
        
        Label {
            width: 120
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Country:"
        }
        
        TextField {
            id: countryField
            
            width: parent.width - 130
            height: 30
        }
        
        Label {
            width: 120
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Language:"
        }
        
        TextField {
            id: languageField
            
            width: parent.width - 130
            height: 30
        }
        
        Label {
            width: 120
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Source:"
        }
        
        TextField {
            id: sourceField
            
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
            text: "Add station"
            enabled: (titleField.text) && (sourceField.text)
            onClicked: {
                var data = {};
                data["title"] = titleField.text;
                data["source"] = sourceField.text;
                
                if (genreField.text) {
                    data["genre"] = genreField.text;
                }
                
                if (countryField.text) {
                    data["country"] = countryField.text;
                }
                
                if (languageField.text) {
                    data["language"] = languageField.text;
                }
                
                resultArea.text = "";
                request.data = data;
                request.post();
            }
        }
        
        Label {
            width: parent.width
            height: 30
            verticalAlignment: Text.AlignVCenter
            text: "Result:"
        }
        
        TextArea {
            id: resultArea
            
            width: parent.width
            height: parent.height - 80
        }
    }
    
    CuteRadioRequest {
        id: request
        
        url: MY_STATIONS_URL
        authRequired: true
        onStatusChanged: {
            if (status == CuteRadioRequest.Ready) {
                for (var att in result) {
                    resultArea.text += (att + ": " + result[att] + "\n");
                }
            }
        }
    }
}
