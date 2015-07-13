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
import org.marxoft.cuteradio 1.0

Window {
    id: root
    
    property string query
    
    title: qsTr("Search") + " ('" + query + "')"
    menuBar: MenuBar {
        NowPlayingMenuItem {}
        
        SleepTimerMenuItem {}
        
        MenuItem {
            text: qsTr("Reload")
            onTriggered: stationModel.searchStations(root.query)
        }
    }
    
    ListView {
        id: view
        
        anchors.fill: parent
        focus: true
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        model: stationModel
        delegate: StationDelegate {
            onClicked: if (request.status != CuteRadioRequest.Loading) player.playStation(stationModel.itemData(index));
            onPressAndHold: contextMenu.popup()
        }
    }
    
    Menu {
        id: contextMenu
        
        MenuItem {
            text: qsTr("Show details")
            onTriggered: dialogs.showDetailsDialog()
        }
        
        MenuItem {
            text: stationModel.data(view.currentIndex, "is_favourite") ? qsTr("Delete from favourites")
                                                                       : qsTr("Add to favourites")
            
            onTriggered: stationModel.data(view.currentIndex, "is_favourite")
                         ? request.deleteFromFavourites(stationModel.data(view.currentIndex, "favourite_id"))
                         : request.addToFavourites(stationModel.data(view.currentIndex, "id"))
        }
        
        MenuItem {
            text: qsTr("Add to 'My stations'")
            onTriggered: dialogs.showAddStationDialog()
        }
    }
    
    Label {
        id: noResultsLabel
        
        anchors.fill: view
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: platformStyle.fontSizeLarge
        color: platformStyle.disabledTextColor
        text: qsTr("No stations found")
        visible: false
    }
    
    QtObject {
        id: dialogs
        
        property StationDetailsDialog detailsDialog
        property AddStationDialog addStationDialog
        
        function showDetailsDialog() {
            if (!detailsDialog) {
                detailsDialog = detailsDialogComponent.createObject(root);
            }
            
            detailsDialog.station = stationModel.itemData(view.currentIndex);
            detailsDialog.open();
        }
        
        function showAddStationDialog() {
            if (!addStationDialog) {
                addStationDialog = addStationDialogComponent.createObject(root);
            }
            
            addStationDialog.open();
            
            var station = stationModel.itemData(view.currentIndex);
            addStationDialog.title = station.title;
            addStationDialog.description = station.description;
            addStationDialog.genre = station.genre;
            addStationDialog.country = station.country;
            addStationDialog.language = station.language;
            addStationDialog.logo = station.logo;
            addStationDialog.source = station.source;
        }
    }
    
    Component {
        id: detailsDialogComponent
        
        StationDetailsDialog {}
    }
    
    Component {
        id: addStationDialogComponent

        AddStationDialog {
            onAccepted: informationBox.information(qsTr("Station added to 'My stations'"));
        }
    }
    
    CuteRadioRequest {
        id: request
        
        property string stationId
        
        function addToFavourites(id) {
            stationId = id;
            url = FAVOURITES_URL;
            data = { "station_id": id };
            post();
        }
        
        function deleteFromFavourites(id) {
            stationId = id;
            url = FAVOURITES_URL + "/" + id;
            deleteResource();
        }
        
        function addToMyStations(station) {
            stationId = station.id;
            url = MY_STATIONS_URL;
            data = {
                "title": station.title,
                "description": station.description,
                "genre": station.genre,
                "country": station.country,
                "language": station.language,
                "logo": station.logo,
                "source": station.source
            };
            post();
        }
        
        authRequired: true
        onStatusChanged: {
            switch (status) {
            case CuteRadioRequest.Loading:
                root.showProgressIndicator = true;
                return;
            case CuteRadioRequest.Ready: {
                if (url == MY_STATIONS_URL) {
                    informationBox.information(qsTr("Station added to 'My stations'"));
                }
                else if (result.id) {
                    stationModel.setItemData(stationModel.match("id", stationId), result);
                }
                else {
                    stationModel.setData(stationModel.match("favourite_id", stationId), false, "is_favourite");
                }
                
                break;
            }
            case CuteRadioRequest.Error:
                informationBox.information(errorString);
                break;
            default:
                break;
            }
            
            root.showProgressIndicator = false;
        }
    }
    
    Connections {
        target: stationModel
        onStatusChanged: {
            switch (stationModel.status) {
            case StationModel.Loading: {
                root.showProgressIndicator = true;
                noResultsLabel.visible = false;
                return;
            }
            case StationModel.Error:
                informationBox.information(stationModel.errorString);
                break;
            default:
                break;
            }
            
            root.showProgressIndicator = false;
            noResultsLabel.visible = (stationModel.count == 0);
        }
    }
    
    Component.onCompleted: {
        stationModel.source = "search$" + root.query;
        stationModel.searchStations(root.query);
    }
}
