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
import CuteRadio 1.0 as CuteRadio
import CuteRadioApp 1.0

ApplicationWindow {
    id: window
    
    visible: true
    title: "cuteRadio"
    menuBar: MenuBar {
        NowPlayingMenuItem {}
        
        SleepTimerMenuItem {}
        
        MenuItem {
            action: playUrlAction
        }
        
        MenuItem {
            action: searchAction
        }
        
        MenuItem {
            action: addStationAction
        }
        
        MenuItem {
            text: qsTr("Account")
            enabled: Settings.token == ""
            onTriggered: popupManager.open(Qt.resolvedUrl("AccountDialog.qml"), window)
        }
        
        MenuItem {
            action: settingsAction
        }
        
        MenuItem {
            text: qsTr("About")
            onTriggered: popupManager.open(Qt.resolvedUrl("AboutDialog.qml"), window)
        }
    }
    
    Action {
        id: playUrlAction
        
        text: qsTr("Play URL")
        shortcut: Settings.playUrlShortcut
        autoRepeat: false
        onTriggered: popupManager.open(Qt.resolvedUrl("PlayUrlDialog.qml"), window)
    }
    
    Action {
        id: searchAction
        
        text: qsTr("Search")
        shortcut: Settings.searchShortcut
        autoRepeat: false
        onTriggered: popupManager.open(Qt.resolvedUrl("SearchDialog.qml"), window)
    }
    
    Action {
        id: addStationAction
        
        text: qsTr("Add station")
        shortcut: Settings.addStationShortcut
        autoRepeat: false
        enabled: Settings.token != ""
        onTriggered: popupManager.open(Qt.resolvedUrl("AddStationDialog.qml"), window)
    }
    
    Action {
        id: settingsAction
        
        text: qsTr("Settings")
        shortcut: Settings.settingsShortcut
        autoRepeat: false
        onTriggered: popupManager.open(Qt.resolvedUrl("SettingsDialog.qml"), window)
    }
    
    Action {
        id: togglePlaybackAction
        
        shortcut: Settings.togglePlaybackShortcut
        shortcutContext: Qt.ApplicationShortcut
        autoRepeat: false
        enabled: player.currentStation.id != ""
        onTriggered: player.playing ? player.stop() : player.restart()
    }
    
    Action {
        id: playbackNextAction
        
        shortcut: Settings.playbackNextShortcut
        shortcutContext: Qt.ApplicationShortcut
        autoRepeat: false
        onTriggered: playlist.next()
    }
        
    Action {
        id: playbackPreviousAction
        
        shortcut: Settings.playbackPreviousShortcut
        shortcutContext: Qt.ApplicationShortcut
        autoRepeat: false
        onTriggered: playlist.previous()
    }
    
    Action {
        id: nowPlayingAction
        
        text: player.currentStation.title
        iconSource: player.playing ? "/etc/hildon/theme/mediaplayer/Play.png" : "/etc/hildon/theme/mediaplayer/Stop.png"
        shortcut: Settings.nowPlayingShortcut
        shortcutContext: Qt.ApplicationShortcut
        autoRepeat: false
        enabled: (player.currentStation.id != "") && (windowStack.currentWindow.objectName != "NowPlayingWindow")
        onTriggered: windowStack.push(Qt.resolvedUrl("NowPlayingWindow.qml"))
    }
    
    Action {
        id: sleepTimerAction
        
        text: qsTr("Sleep timer") + (sleepTimer.running ? " (" + Utils.formatMSecs(sleepTimer.remaining) + ")" : "")
        shortcut: Settings.sleepTimerShortcut
        shortcutContext: Qt.ApplicationShortcut
        autoRepeat: false
        checkable: true
        checked: sleepTimer.running
        enabled: player.currentStation.id != ""
        onTriggered: {
            sleepTimer.running = !sleepTimer.running;
            informationBox.information(sleepTimer.running ? qsTr("Sleep timer set for")
            + " " + Settings.sleepTimerDuration + " " + qsTr("minutes")
            : qsTr("Sleep timer disabled"));
        }
    }
    
    ListView {
        id: view
        
        anchors.fill: parent
        focus: true
        model: HomescreenModel {}
        delegate: HomescreenDelegate {
            onClicked: {
                switch (index) {
                case 0:
                    windowStack.push(Qt.resolvedUrl("StationsWindow.qml"), {title: name}).reload();
                    break;
                case 1:
                    windowStack.push(Qt.resolvedUrl("GenresWindow.qml")).reload();
                    break;
                case 2:
                    windowStack.push(Qt.resolvedUrl("CountriesWindow.qml")).reload();
                    break;
                case 3:
                    windowStack.push(Qt.resolvedUrl("LanguagesWindow.qml")).reload();
                    break;
                case 4:
                    windowStack.push(Qt.resolvedUrl("StationsWindow.qml"),
                    {title: name, resource: "playedstations"}).reload();
                    break;
                case 5:
                    windowStack.push(Qt.resolvedUrl("StationsWindow.qml"),
                    {title: name, resource: "favourites"}).reload();
                    break;
                case 6:
                    windowStack.push(Qt.resolvedUrl("StationsWindow.qml"),
                    {title: name, filters: {mine: true}}).reload();
                    break;
                default:
                    break;
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
        
    Audio {
        id: player
        
        property variant currentStation: ({
            "id": "",
            "title": qsTr("(unknown station)"),
            "description": "",
            "genre": qsTr("(unknown genre)"),
            "country": qsTr("(unknown country)"),
            "language": qsTr("(unknown language)"),
            "source": ""
        })
        
        function playStation(station) {
            currentStation = station;
            
            if (Utils.isPlaylist(station.source)) {
                extractor.getStreamUrl(station.source);
            }
            else {
                playlist.clearItems();
                playlist.appendSource(station.source);
                play();
            }
        }
        
        function restart() {
            if (Utils.isPlaylist(currentStation.source)) {
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
                       stationPlayedRequest.insert({stationId: currentStation.id}, "/playedstations");
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
    
    CuteRadio.ResourcesRequest {
        id: stationPlayedRequest
        
        accessToken: Settings.token
        onStatusChanged: if (status == CuteRadio.ResourcesRequest.Error) informationBox.information(errorString);
    }
    
    Component.onCompleted: screen.orientationLock = Settings.screenOrientation
}
