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
import QtMultimediaKit 1.1
import org.marxoft.cuteradio 1.0

Rectangle {
    id: root
    
    width: 800
    height: 600
    
    Row {
        id: row
        
        property int buttonWidth: Math.floor((width - (spacing * 6)) / 7)
        
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 10
        }

        spacing: 10
        
        Button {
            width: row.buttonWidth
            text: "Authentication"
            border.color: tabGroup.currentTab == authenticationTab ? "green" : "black"
            onClicked: tabGroup.currentTab = authenticationTab
        }
        
        Button {
            width: row.buttonWidth
            text: "Genres"
            border.color: tabGroup.currentTab == genresTab ? "green" : "black"
            onClicked: {
                tabGroup.currentTab = genresTab;
                
                if (genresTab.model.count == 0) {
                    genresTab.model.getGenres();
                }
            }
        }
        
        Button {
            width: row.buttonWidth
            text: "Countries"
            border.color: tabGroup.currentTab == countriesTab ? "green" : "black"
            onClicked: {
                tabGroup.currentTab = countriesTab;
                
                if (countriesTab.model.count == 0) {
                    countriesTab.model.getCountries();
                }
            }
        }
        
        Button {
            width: row.buttonWidth
            text: "Languages"
            border.color: tabGroup.currentTab == languagesTab ? "green" : "black"
            onClicked: {
                tabGroup.currentTab = languagesTab;
                
                if (languagesTab.model.count == 0) {
                    languagesTab.model.getLanguages();
                }
            }
        }
        
        Button {
            width: row.buttonWidth
            text: "Stations"
            border.color: tabGroup.currentTab == stationsTab ? "green" : "black"
            onClicked: tabGroup.currentTab = stationsTab
        }
        
        Button {
            width: row.buttonWidth
            text: "New station"
            border.color: tabGroup.currentTab == newStationTab ? "green" : "black"
            onClicked: tabGroup.currentTab = newStationTab
        }
        
        Button {
            width: row.buttonWidth
            text: "Reload"
            onClicked: if (tabGroup.currentTab.model) tabGroup.currentTab.model.reloadItems();
        }
    }
    
    TabGroup {
        id: tabGroup

        anchors {
            left: parent.left
            right: parent.right
            top: row.bottom
            bottom: audioControls.top
            margins: 10
        }
        
        AuthenticationTab {
            id: authenticationTab
        }
        
        GenresTab {
            id: genresTab
        }
        
        CountriesTab {
            id: countriesTab
        }
        
        LanguagesTab {
            id: languagesTab
        }
        
        StationsTab {
            id: stationsTab
        }
        
        NewStationTab {
            id: newStationTab
        }
        
        Component.onCompleted: currentTab = authenticationTab
    }
    
    Rectangle {
        id: audioControls
        
        height: 100
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 10
        }
        
        border {
            width: 1
            color: "black"
        }
        
        Flow {
            id: flow
            
            width: 150
            anchors {
                left: parent.left
                top: parent.top
                margins: 10
            }
            
            spacing: 10
            
            Button {
                id: playButton
                
                width: parent.width
                text: player.playing ? "Pause" : "Play"
                enabled: player.source != ""
                onClicked: player.playing = !player.playing
            }
        
            Button {
                width: 70
                text: "Volume-"
                enabled: player.volume > 0.02
                onClicked: player.volume -= 0.02
            }
            
            Button {
                width: 70
                text: "Volume+"
                enabled: player.volume < 0.98
                onClicked: player.volume += 0.02
            }
        }
        
        Grid {
            id: grid
            
            property int labelWidth: Math.floor((width - spacing) / 2)
            
            anchors {
                left: flow.right
                right: parent.right
                top: parent.top
                margins: 10
            }
            
            columns: 2
            spacing: 10
            
            Label {
                width: grid.labelWidth
                text: "Title: " + (player.metaData.title ? player.metaData.title : player.currentStation.title)
            }
            
            Label {
                width: grid.labelWidth
                text: "Artist: " + (player.metaData.artist ? player.metaData.artist : "None")
            }
            
            Label {
                width: grid.labelWidth
                text: "Genre: " + (player.metaData.genre ? player.metaData.genre : player.currentStation.genre)
            }
            
            Label {
                width: grid.labelWidth
                text: "Source: " + (player.source ? player.source : player.currentStation.source)
            }
        }
    }
    
    Audio {
        id: player
        
        property variant currentStation: { "id": "", "title": "None", "genre": "None", "source": "None" }
        
        function playStation(station) {
            currentStation = station;
            
            if (Utils.urlIsPlaylist(station.source)) {
                extractor.getStreamUrl(station.source);
            }
            else {
                source = station.source;
                play();
            }
        }
        
        onStarted: if (Settings.sendPlayedStationsData) playedStationsNotifier.post();
    }
    
    StreamExtractor {
        id: extractor
        
        onStatusChanged: {
            if (status == StreamExtractor.Ready) {
                player.source = result;
                player.play();
            }
        }
    }
    
    CuteRadioRequest {
        id: playedStationsNotifier
        
        url: RECENTLY_PLAYED_STATIONS_URL
        data: { "station_id": player.currentStation.id }
        authRequired: true
    }
}
