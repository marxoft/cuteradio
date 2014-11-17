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
    
    windowTitle: qsTr("My stations")
    tools: [
        NowPlayingAction {},
        
        SleepTimerAction {},
        
        Action {
            text: qsTr("Reload")
            onTriggered: stationModel.getMyStations()
        },
        
        Action {
            text: qsTr("Add station")
            onTriggered: {
                loader.sourceComponent = addStationDialog;
                loader.item.open();
            }
        }
    ]
    
    actions: Action {
        shortcut: "Ctrl+R"
        onTriggered: stationModel.getMyStations()
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
                text: qsTr("Edit details")
                
                onTriggered: {
                    var station = stationModel.itemData(QModelIndex.row(view.currentIndex));
                    loader.sourceComponent = addStationDialog;
                    loader.item.open();
                    loader.item.stationId = station.id;
                    loader.item.title = station.title;
                    loader.item.description = station.description;
                    loader.item.genre = station.genre;
                    loader.item.country = station.country;
                    loader.item.language = station.language;
                    loader.item.logo = station.logo;
                    loader.item.source = station.source;
                    view.currentIndex = QModelIndex.parent(view.currentIndex);
                }
            },
            
            Action {
                text: qsTr("Delete from 'My stations'")
                onTriggered: {
                    request.deleteFromMyStations(stationModel.data(QModelIndex.row(view.currentIndex), "id"));
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
        id: addStationDialog
        
        AddStationDialog {
             onAccepted: {
                if (stationId) {
                    stationModel.setItemData(stationModel.match("id", stationId), result);
                    infobox.showMessage(qsTr("Station updated"));
                }
                else {
                    stationModel.insertItem(0, result);
                }
            }
        }
    }
    
    Component {
        id: detailsDialog
        
        StationDetailsDialog {}
    }
    
    CuteRadioRequest {
        id: request
        
        property string stationId
        
        function deleteFromMyStations(id) {
            stationId = id
            url = MY_STATIONS_URL + "/" + id;
            deleteResource();
        }
        
        authRequired: true
        onStatusChanged: {
            switch (status) {
            case CuteRadioRequest.Loading:
                root.showProgressIndicator = true;
                return;
            case CuteRadioRequest.Ready: {
                stationModel.removeItem(stationModel.match("id", stationId));
                noResultsLabel.visible = (stationModel.count == 0);
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
        if ((stationModel.source != "mystations") || (stationModel.count == 0)) {
            stationModel.source = "mystations";
            stationModel.getMyStations();
        }
    }
}
