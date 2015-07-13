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

Dialog {
    id: root
    
    property variant station: {
        "id": "",
        "title": qsTr("Unknown"),
        "description": "",
        "genre": qsTr("Unknown"),
        "country": qsTr("Unknown"),
        "language": qsTr("Unknown"),
        "logo": "",
        "source": "",
        "is_favourite": false,
        "last_played": ""
    }
    
    height: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation ? 680 : 360
    title: qsTr("Station details")
    
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
            }
            spacing: platformStyle.paddingMedium
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                text: qsTr("Title")
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.title
            }
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                text: qsTr("Description")
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.description ? station.description : qsTr("No description")
            }
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                text: qsTr("Genre")
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.genre
            }
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                text: qsTr("Country")
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.country
            }
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                text: qsTr("Language")
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.language
            }
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                text: qsTr("Source")
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.source
            }
            
            Label {
                width: parent.width
                color: platformStyle.secondaryTextColor
                text: qsTr("Last played")
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.last_played ? station.last_played : qsTr("Never")
            }
        }
    }
}
