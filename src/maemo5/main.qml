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
import org.hildon.multimedia 1.0
import org.marxoft.cuteradio 1.0

Window {
    id: window
    
    windowTitle: "cuteRadio"
    tools: [
        NowPlayingAction {},
        
        SleepTimerAction {},
        
        Action {
            text: qsTr("Play URL")
            onTriggered: {
                loader.sourceComponent = urlDialog;
                loader.item.open();
            }
        },
        
        Action {
            text: qsTr("Search")
            enabled: Settings.token != ""
            onTriggered: {
                loader.sourceComponent = searchDialog;
                loader.item.open();
            }
        },
        
        Action {
            text: qsTr("Account")
            enabled: Settings.token == ""
            onTriggered: {
                loader.sourceComponent = accountDialog;
                loader.item.open();
            }
        },
        
        Action {
            text: qsTr("Settings")
            onTriggered: {
                loader.sourceComponent = settingsDialog;
                loader.item.open();
            }
        },
        
        Action {
            text: qsTr("About")
            onTriggered: {
                loader.sourceComponent = aboutDialog;
                loader.item.open();
            }
        }
    ]
    
    actions: [
        Action {
            shortcut: "Ctrl+U"
            onTriggered: {
                loader.sourceComponent = urlDialog;
                loader.item.open();
            }
        },
        
        Action {
            shortcut: "Ctrl+S"
            enabled: Settings.token != ""
            onTriggered: {
                loader.sourceComponent = searchDialog;
                loader.item.open();
            }
        }
    ]
    
    ListView {
        id: view
        
        anchors.fill: parent
        focusPolicy: Qt.NoFocus
        model: HomescreenModel {}
        delegate: HomescreenDelegate {}
        onClicked: {
            if (!Settings.token) {
                infobox.showMessage(qsTr("Please login or register a cuteRadio account"));
                loader.sourceComponent = accountDialog;
                loader.item.open();
            }
            else {
                switch (QModelIndex.row(currentIndex)) {
                case 0: {
                    pageStack.push(Qt.resolvedUrl("StationsPage.qml"), { windowTitle: qsTr("All stations") });
                    
                    if ((stationModel.source != "stations") || (stationModel.count == 0)) {
                        stationModel.source = "stations";
                        stationModel.getStations();
                    }
                    
                    break;
                }
                case 1:
                    pageStack.push(Qt.resolvedUrl("GenresPage.qml"), {});
                    break;
                case 2:
                    pageStack.push(Qt.resolvedUrl("CountriesPage.qml"), {});
                    break;
                case 3:
                    pageStack.push(Qt.resolvedUrl("LanguagesPage.qml"), {});
                    break;
                case 4:
                    pageStack.push(Qt.resolvedUrl("RecentlyPlayedPage.qml"), {});
                    break;
                case 5:
                    pageStack.push(Qt.resolvedUrl("FavouritesPage.qml"), {});
                    break;
                case 6:
                    pageStack.push(Qt.resolvedUrl("MyStationsPage.qml"), {});
                    break;
                default:
                    break;
                }
            }
            
            currentIndex = QModelIndex.parent(currentIndex);
        }
    }
    
    InformationBox {
        id: infobox
        
        function showMessage(message) {
            minimumHeight = 70;
            timeout = InformationBox.DefaultTimeout;
            infoLabel.text = message;
            open();
        }
        
        function showError(message) {
            minimumHeight = 120;
            timeout = InformationBox.NoTimeout;
            infoLabel.text = message;
            open();
        }
        
        content: Label {
            id: infoLabel
            
            anchors.fill: parent
            alignment: Qt.AlignCenter
            color: platformStyle.reversedTextColor
            wordWrap: true
        }
    }
    
    Loader {
        id: loader
    }
    
    Component {
        id: searchDialog
        
        SearchDialog {}
    }
    
    Component {
        id: urlDialog
        
        PlayUrlDialog {}
    }
    
    Component {
        id: accountDialog
        
        AccountDialog {}
    }
    
    Component {
        id: settingsDialog
        
        SettingsDialog {}
    }
    
    Component {
        id: aboutDialog
        
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
        onError: infobox.showError(errorString)
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
                infobox.showMessage(qsTr("Retrieving the stream URL from the playlist"));
                break;
            case StreamExtractor.Ready: {
                playlist.clearItems();
                playlist.appendSource(result);
                player.play();
                break;
            }
            case StreamExtractor.Error:
                infobox.showError(errorString);
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
        onStatusChanged: if (status == CuteRadioRequest.Error) infobox.showError(errorString);
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
