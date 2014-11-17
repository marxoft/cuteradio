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
import com.nokia.meego 1.0
import org.marxoft.cuteradio 1.0

PageStackWindow {
    id: appWindow

    showStatusBar: true
    showToolBar: true
    initialPage: MainPage {
        id: mainPage
    }
    platformStyle: PageStackWindowStyle {
        id: appStyle

        background: "image://theme/meegotouch-applicationpage-background-inverted"
        backgroundFillMode: Image.Stretch
        cornersVisible: true
    }

    TitleHeader {
        id: titleHeader
    }

    MyInfoBanner {
        id: infoBanner
    }

    ProgressDialog {
        id: progressDialog
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
            "logo": "",
            "source": ""
        }
        
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
        
        onError: infoBanner.showMessage(errorString)
        onStarted: if ((Settings.sendPlayedStationsData)
                       && (Settings.token)
                       && (currentStation.id))
                       stationPlayedRequest.post();
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
    
    CuteRadioRequest {
        id: stationPlayedRequest
        
        url: RECENTLY_PLAYED_STATIONS_URL
        data: { "station_id": player.currentStation.id }
        authRequired: true
        onStatusChanged: if (status == CuteRadioRequest.Error) infoBanner.showMessage(errorString);
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

    Component.onCompleted: theme.inverted = true
}
