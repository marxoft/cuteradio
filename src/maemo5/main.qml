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
import org.hildon.multimedia 1.0
import org.marxoft.cuteradio 1.0

ApplicationWindow {
    id: window
    
    visible: true
    title: "cuteRadio"
    menuBar: MenuBar {
        NowPlayingMenuItem {}
        
        SleepTimerMenuItem {}
        
        MenuItem {
            text: qsTr("Play URL")
            onTriggered: dialogs.showUrlDialog()
        }
        
        MenuItem {
            text: qsTr("Search")
            enabled: Settings.token != ""
            onTriggered: dialogs.showSearchDialog()
        }
        
        MenuItem {
            text: qsTr("Account")
            enabled: Settings.token == ""
            onTriggered: dialogs.showAccountDialog()
        }
        
        MenuItem {
            text: qsTr("Settings")
            onTriggered: dialogs.showSettingsDialog()
        }
        
        MenuItem {
            text: qsTr("About")
            onTriggered: dialogs.showAboutDialog()
        }
    }
    
    ListView {
        id: view
        
        anchors.fill: parent
        focus: true
        model: HomescreenModel {}
        delegate: HomescreenDelegate {
            onClicked: {
                if (!Settings.token) {
                    informationBox.information(qsTr("Please login or register a cuteRadio account"));
                    loader.sourceComponent = accountDialog;
                    loader.item.open();
                }
                else {
                    switch (index) {
                    case 0: {
                        windowStack.push(Qt.resolvedUrl("StationsWindow.qml"), { title: qsTr("All stations") });
                    
                        if ((stationModel.source != "stations") || (stationModel.count == 0)) {
                            stationModel.source = "stations";
                            stationModel.getStations();
                        }
                    
                        break;
                    }
                    case 1:
                        windowStack.push(Qt.resolvedUrl("GenresWindow.qml"));
                        break;
                    case 2:
                        windowStack.push(Qt.resolvedUrl("CountriesWindow.qml"));
                        break;
                    case 3:
                        windowStack.push(Qt.resolvedUrl("LanguagesWindow.qml"));
                        break;
                    case 4:
                        windowStack.push(Qt.resolvedUrl("RecentlyPlayedWindow.qml"));
                        break;
                    case 5:
                        windowStack.push(Qt.resolvedUrl("FavouritesWindow.qml"));
                        break;
                    case 6:
                        windowStack.push(Qt.resolvedUrl("MyStationsWindow.qml"));
                        break;
                    default:
                        break;
                    }
                }            
            }
        }
    }
    
    InformationBox {
        id: informationBox
        
        function information(message) {
            infoLabel.text = message;
            open();
        }
        
        height: infoLabel.height + platformStyle.paddingLarge
        
        Label {
            id: infoLabel
            
            anchors {
                fill: parent
                leftMargin: platformStyle.paddingLarge
                rightMargin: platformStyle.paddingLarge
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: platformStyle.reversedTextColor
            wrapMode: Text.WordWrap
        }
    }
    
    QtObject {
        id: dialogs
        
        property SearchDialog searchDialog
        property PlayUrlDialog urlDialog
        property AccountDialog accountDialog
        property SettingsDialog settingsDialog
        property AboutDialog aboutDialog
        
        function showSearchDialog() {
            if (!searchDialog) {
                searchDialog = searchDialogComponent.createObject(window);
            }
            
            searchDialog.open();
        }
        
        function showUrlDialog() {
            if (!urlDialog) {
                urlDialog = urlDialogComponent.createObject(window);
            }
            
            urlDialog.open();
        }
        
        function showAccountDialog() {
            if (!accountDialog) {
                accountDialog = accountDialogComponent.createObject(window);
            }
            
            accountDialog.open();
        }
        
        function showSettingsDialog() {
            if (!settingsDialog) {
                settingsDialog = settingsDialogComponent.createObject(window);
            }
            
            settingsDialog.open();
        }
        
        function showAboutDialog() {
            if (!aboutDialog) {
                aboutDialog = aboutDialogComponent.createObject(window);
            }
            
            aboutDialog.open();
        }        
    }
    
    Component {
        id: searchDialogComponent
        
        SearchDialog {}
    }
    
    Component {
        id: urlDialogComponent
        
        PlayUrlDialog {}
    }
    
    Component {
        id: accountDialogComponent
        
        AccountDialog {}
    }
    
    Component {
        id: settingsDialogComponent
        
        SettingsDialog {}
    }
    
    Component {
        id: aboutDialogComponent
        
        AboutDialog {}
    }
    
    Audio {
        id: player
        
        property variant currentStation: {
            "id": "",
            "title": qsTr("(unknown station)"),
            "description": "",
            "genre": qsTr("(unknown genre)"),
            "country": qsTr("(unknown country)"),
            "language": qsTr("(unknown language)"),
            "logo": "",
            "source": ""
        }
        
        function playStation(station) {
            currentStation = station;
            
            if (Utils.urlIsPlaylist(station.source)) {
                extractor.getStreamUrl(station.source);
            }
            else {
                playlist.clearItems();
                playlist.appendSource(station.source);
                play();
            }
        }
        
        function restart() {
            if (Utils.urlIsPlaylist(currentStation.source)) {
                extractor.getStreamUrl(currentStation.source);
            }
            else {
                play();
            }
        }
        
        tickInterval: 0
        onError: informationBox.information(errorString)
        onStarted: if ((Settings.sendPlayedStationsData)
                       && (Settings.token)
                       && (currentStation.id))
                       stationPlayedRequest.post();
    }
    
    NowPlayingModel {
        id: playlist
        
        mediaType: MediaType.Radio
    }
    
    Timer {
        id: sleepTimer
        
        property int remaining
        
        interval: 60000
        repeat: true
        onRunningChanged: remaining = (Settings.sleepTimerDuration * 60000)
        onTriggered: {
            remaining -= interval;
            
            if (remaining <= 0) {
                stop();
                player.stop();
            }
        }
    }
    
    StreamExtractor {
        id: extractor
        
        onStatusChanged: {
            switch (status) {
            case StreamExtractor.Loading:
                informationBox.information(qsTr("Retrieving the stream URL from the playlist"));
                break;
            case StreamExtractor.Ready: {
                playlist.clearItems();
                playlist.appendSource(result);
                player.play();
                break;
            }
            case StreamExtractor.Error:
                informationBox.information(errorString);
                break;
            default:
                break;
            }
        }
    }
    
    CuteRadioRequest {
        id: stationPlayedRequest
        
        url: RECENTLY_PLAYED_STATIONS_URL
        data: { "station_id": player.currentStation.id }
        authRequired: true
        onStatusChanged: if (status == CuteRadioRequest.Error) informationBox.information(errorString);
    }
    
    StationModel {
        id: stationModel
        
        property string source
    }
    
    NameCountModel {
        id: genreModel
    }
    
    NameCountModel {
        id: countryModel
    }
    
    NameCountModel {
        id: languageModel
    }
    
    Component.onCompleted: screen.orientationLock = Settings.screenOrientation
}
