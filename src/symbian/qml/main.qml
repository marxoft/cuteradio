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

import QtQuick 1.1
import QtMultimediaKit 1.1
import com.nokia.symbian 1.1
import CuteRadio 1.0 as CuteRadio
import CuteRadioApp 1.0

AppWindow {
    id: appWindow

    showStatusBar: true
    showToolBar: true
    initialPage: MainPage {
        id: mainPage
    }

    TitleHeader {
        id: titleHeader
    }

    MyInfoBanner {
        id: infoBanner
    }

    VolumeControl {
        id: volumeControl
    }

    VolumeKeys {
        id: volumeKeys
    }

    ProgressDialog {
        id: progressDialog

        onRejected: updateManager.cancel()
    }

    Audio {
        id: player

        property variant currentStation: {
            "id": "",
            "title": qsTr("Unknown"),
            "description": "",
            "genre": qsTr("Unknown"),
            "country": qsTr("Unknown"),
            "language": qsTr("Unknown"),
            "source": ""
        }

        function playStation(station) {
            currentStation = station;

            if (Utils.isPlaylist(station.source)) {
                extractor.getStreamUrl(station.source);
            }
            else {
                source = "";
                source = station.source;
                play();
            }
        }
        
        function restart() {
            if (Utils.isPlaylist(currentStation.source)) {
                extractor.getStreamUrl(currentStation.source);
            }
            else {
                source = "";
                source = currentStation.source;
                play();
            }
        }

        volume: volumeKeys.volume
        onError: if (error > 1) infoBanner.showMessage(errorString);
        onStarted: if ((Settings.sendPlayedStationsData)
                           && (Settings.token)
                           && (currentStation.id))
                       stationPlayedRequest.insert({stationId: currentStation.id}, "/playedstations");
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
                infoBanner.showMessage(qsTr("Retrieving the stream URL from the playlist"));
                break;
            case StreamExtractor.Ready: {
                player.source = "";
                player.source = result;
                player.play();
                break;
            }
            case StreamExtractor.Error:
                infoBanner.showMessage(errorString);
                break;
            default:
                break;
            }
        }
    }

    CuteRadio.ResourcesRequest {
        id: stationPlayedRequest
        
        accessToken: Settings.token
        onStatusChanged: if (status == CuteRadio.ResourcesRequest.Error) infoBanner.showMessage(errorString);
    }
    
    UpdateManager {
        id: updateManager
        
        url: "http://www.marxoft.co.uk/projects/cuteradio/symbian/update.php"
        onStatusChanged: {
            switch (status) {
            case UpdateManager.Loading:
                progressDialog.showProgress(statusString);
                break;
            case UpdateManager.Ready:
                progressDialog.showMessage(statusString);
                break;
            case UpdateManager.Error:
                progressDialog.showError(statusString)
                break;
            default:
                break;
            }
        }
    }
}
