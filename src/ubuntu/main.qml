/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
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

import QtQuick 2.2
import QtMultimedia 5.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import org.marxoft.cuteradio 1.0

MainView {
    id: mainView

    objectName: "mainView"
    applicationName: "cuteradio"
    useDeprecatedToolbar: false
    automaticOrientation: Settings.screenOrientation == 0
    	
	PageStack {
		id: pageStack
	}
	
	ProgressDialog {
		id: progressDialog
	}
	
	QtObject {
		id: infoBanner
        
        function showMessage(message) {
            var banner = PopupUtils.open(Qt.resolvedUrl("InfoBanner.qml"), pageStack.currentPage);
            banner.text = message;
        }
	}
	
	Audio {
        id: player
        
        property variant currentStation: {
            "id": "",
            "title": i18n.tr("Unknown"),
            "description": "",
            "genre": i18n.tr("Unknown"),
            "country": i18n.tr("Unknown"),
            "language": i18n.tr("Unknown"),
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
        
        function restart() {
            if (Utils.urlIsPlaylist(currentStation.source)) {
                extractor.getStreamUrl(currentStation.source);
            }
            else {
                play();
            }
        }
        
        onError: infoBanner.showMessage(errorString)
        onPlaying: if ((Settings.sendPlayedStationsData)
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
                infoBanner.showMessage(i18n.tr("Retrieving the stream URL from the playlist"));
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
		
	Component.onCompleted: pageStack.push(Qt.resolvedUrl("MainPage.qml"))
}
