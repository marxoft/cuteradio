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
import CuteRadio 1.0 as CuteRadio

Window {
    id: root
    
    property alias resource: stationModel.resource
    property alias filters: stationModel.filters
    
    function reload() {
        stationModel.reload();
    }

    menuBar: MenuBar {
        NowPlayingMenuItem {}
        
        SleepTimerMenuItem {}
        
        MenuItem {
            text: qsTr("Reload")
            onTriggered: stationModel.reload()
        }
    }
    
    ListView {
        id: view
        
        anchors.fill: parent
        focus: true
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        model: CuteRadio.StationsModel {
            id: stationModel
            
            accessToken: Settings.token
            onStatusChanged: {
                switch (status) {
                case CuteRadio.ResourcesRequest.Loading: {
                    root.showProgressIndicator = true;
                    noResultsLabel.visible = false;
                    return;
                }
                case CuteRadio.ResourcesRequest.Error:
                    informationBox.information(stationModel.errorString);
                    break;
                default:
                    break;
                }
            
                root.showProgressIndicator = false;
                noResultsLabel.visible = (stationModel.count == 0);
            }
        }
        delegate: StationDelegate {
            onClicked: player.playStation(stationModel.get(index));
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
            text: qsTr("Edit details")
            enabled: stationModel.get(view.currentIndex).creatorId == Settings.userId
            onTriggered: dialogs.showEditStationDialog()
        }
        
        MenuItem {
            text: stationModel.get(view.currentIndex).favourite ? qsTr("Delete from favourites")
                                                                : qsTr("Add to favourites")
            enabled: Settings.token != ""
            onTriggered: stationModel.get(view.currentIndex).favourite
                         ? request.deleteFromFavourites(stationModel.get(view.currentIndex).id)
                         : request.addToFavourites(stationModel.get(view.currentIndex).id)
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
        property AddStationDialog editStationDialog
        
        function showDetailsDialog() {
            if (!detailsDialog) {
                detailsDialog = detailsDialogComponent.createObject(root);
            }
            
            detailsDialog.station = stationModel.get(view.currentIndex);
            detailsDialog.open();
        }
        
        function showEditStationDialog() {
            if (!editStationDialog) {
                editStationDialog = editStationDialogComponent.createObject(root);
            }
            
            var station = stationModel.get(view.currentIndex);
            editStationDialog.title = station.title;
            editStationDialog.description = station.description;
            editStationDialog.genre = station.genre;
            editStationDialog.country = station.country;
            editStationDialog.language = station.language;
            editStationDialog.source = station.source;
            editStationDialog.open();
        }
    }
    
    Component {
        id: detailsDialogComponent
        
        StationDetailsDialog {}
    }
    
    Component {
        id: editStationDialogComponent

        AddStationDialog {
            onAccepted: stationModel.set(stationModel.find("id", result.id), result)
        }
    }
    
    CuteRadio.ResourcesRequest {
        id: request
        
        property string stationId
        
        function addToFavourites(id) {
            stationId = id;
            insert({stationId: id}, "/favourites");
        }
        
        function deleteFromFavourites(id) {
            stationId = id;
            del("/favourites/" + id);
        }
        
        accessToken: Settings.token
        onStatusChanged: {
            switch (status) {
            case CuteRadio.ResourcesRequest.Loading:
                root.showProgressIndicator = true;
                return;
            case CuteRadio.ResourcesRequest.Ready: {
                if (stationModel.resource == "favourites") {
                    stationModel.remove(stationModel.find("id", stationId));
                }
                else {
                    stationModel.setProperty(stationModel.find("id", stationId), "favourite", result.id ? true : false);
                }
                
                break;
            }
            case CuteRadio.ResourcesRequest.Error:
                informationBox.information(errorString);
                break;
            default:
                break;
            }
            
            root.showProgressIndicator = false;
        }
    }
}
