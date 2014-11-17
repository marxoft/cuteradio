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
import org.marxoft.cuteradio 1.0

Page {
    id: root
    
    property string query
    
    windowTitle: qsTr("Search") + " ('" + query + "')"
    tools: [
        NowPlayingAction {},
        
        SleepTimerAction {},
        
        Action {
            text: qsTr("Reload")
            onTriggered: stationModel.searchStations(root.query)
        }
    ]
    
    actions: Action {
        shortcut: "Ctrl+R"
        onTriggered: stationModel.searchStations(root.query)
    }
    
    ListView {
        id: view
        
        anchors.fill: parent
        focusPolicy: Qt.NoFocus
        horizontalScrollMode: ListView.ScrollPerItem
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        contextMenuPolicy: request.status == CuteRadioRequest.Loading ? Qt.NoContextMenu : Qt.ActionsContextMenu
        model: stationModel
        delegate: StationDelegate {}
        actions: [
            Action {
                text: qsTr("Show details")
                onTriggered: {
                    loader.sourceComponent = detailsDialog;
                    loader.item.station = stationModel.itemData(QModelIndex.row(view.currentIndex));
                    loader.item.open();
                    view.currentIndex = QModelIndex.parent(view.currentIndex);
                }
            },
            
            Action {
                text: stationModel.data(QModelIndex.row(view.currentIndex),
                                        "is_favourite") ? qsTr("Delete from favourites") : qsTr("Add to favourites")
                
                onTriggered: {
                    stationModel.data(QModelIndex.row(view.currentIndex),
                                      "is_favourite")
                                       ? request.deleteFromFavourites(stationModel.data(QModelIndex.row(view.currentIndex),
                                                                                        "favourite_id"))
                                       : request.addToFavourites(stationModel.data(QModelIndex.row(view.currentIndex),
                                                                                   "id"));
                                                                                   
                    view.currentIndex = QModelIndex.parent(view.currentIndex);
                }
            },
            
            Action {
                text: qsTr("Add to 'My stations'")
                onTriggered: {
                    var station = stationModel.itemData(QModelIndex.row(view.currentIndex));
                    loader.sourceComponent = addStationDialog;
                    loader.item.open();
                    loader.item.title = station.title;
                    loader.item.description = station.description;
                    loader.item.genre = station.genre;
                    loader.item.country = station.country;
                    loader.item.language = station.language;
                    loader.item.logo = station.logo;
                    loader.item.source = station.source;
                    view.currentIndex = QModelIndex.parent(view.currentIndex);
                }
            }
        ]
                                        
        onClicked: {
            if (request.status != CuteRadioRequest.Loading) {
                player.playStation(stationModel.itemData(QModelIndex.row(currentIndex)));
            }
            
            currentIndex = QModelIndex.parent(currentIndex);
        }
    }
    
    Label {
        id: noResultsLabel
        
        anchors.fill: view
        alignment: Qt.AlignCenter
        font.pixelSize: platformStyle.fontSizeLarge
        color: platformStyle.disabledTextColor
        text: qsTr("No stations found")
        visible: false
    }
    
    Loader {
        id: loader
    }
    
    Component {
        id: detailsDialog
        
        StationDetailsDialog {}
    }
    
    Component {
        id: addStationDialog

        AddStationDialog {
            onAccepted: infobox.showMessage(qsTr("Station added to 'My stations'"));
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
                    infobox.showMessage(qsTr("Station added to 'My stations'"));
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
                infobox.showError(errorString);
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
                infobox.showError(stationModel.errorString);
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
