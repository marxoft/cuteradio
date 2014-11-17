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
    
    property alias model: stationModel
    
    anchors.fill: parent
    
    Flow {
        id: flow
        
        property int buttonWidth: Math.floor((width - (spacing * 3)) / 4)
        
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 10
        }

        spacing: 10
        
        Button {
            width: flow.buttonWidth
            text: "All stations"
            onClicked: stationModel.getStations()
        }
        
        Button {
            width: flow.buttonWidth
            text: "My stations"
            onClicked: stationModel.getMyStations()
        }
        
        Button {
            width: flow.buttonWidth
            text: "Favourite stations"
            onClicked: stationModel.getFavouriteStations()
        }
        
        Button {
            width: flow.buttonWidth
            text: "Recently played stations"
            onClicked: stationModel.getRecentlyPlayedStations()
        }
        
        TextField {
            id: searchField
            
            width: parent.width - 110
        }
        
        Button {
            width: 100
            text: "Search"
            enabled: searchField.text != ""
            onClicked: stationModel.searchStations(searchField.text)
        }
    }

    ListView {
        id: view

        anchors {
            left: parent.left
            right: parent.right
            top: flow.bottom
            topMargin: 10
            bottom: parent.bottom
        }
        clip: true
        model: StationModel {
            id: stationModel
        }
        delegate: ListDelegate {
            text: title
            subText: genre + " | " + country + " | " + language
            
            Rectangle {
                anchors {
                    fill: parent
                    bottomMargin: 1
                }
                
                color: "green"
                opacity: 0.5
                visible: (!pressed) && (id == player.currentStation.id)
            }
            
            onClicked: player.playStation(stationModel.itemData(index))
        }
    }
}
