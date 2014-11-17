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
    
    height: window.inPortrait ? 680 : 360
    windowTitle: qsTr("Station details")
    content: Flickable {
        id: flicker
        
        anchors.fill: parent
        
        Column {
            id: column
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Title")
            }
            
            Label {
                wordWrap: true
                text: station.title
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Description")
            }
            
            Label {
                wordWrap: true
                text: station.description ? station.description : qsTr("No description")
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Genre")
            }
            
            Label {
                wordWrap: true
                text: station.genre
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Country")
            }
            
            Label {
                wordWrap: true
                text: station.country
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Language")
            }
            
            Label {
                wordWrap: true
                text: station.language
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Source")
            }
            
            Label {
                wordWrap: true
                text: station.source
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Last played")
            }
            
            Label {
                wordWrap: true
                text: station.last_played ? station.last_played : qsTr("Never")
            }
        }
    }
}
