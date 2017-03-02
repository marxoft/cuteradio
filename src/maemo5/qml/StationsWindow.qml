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
            action: reloadAction
        }
    }
    
    Action {
        id: reloadAction
        
        text: qsTr("Reload")
        shortcut: Settings.reloadShortcut
        autoRepeat: false
        onTriggered: stationModel.reload()
    }
    
    Action {
        id: detailsAction
        
        text: qsTr("Show details")
        shortcut: Settings.stationDetailsShortcut
        autoRepeat: false
        enabled: view.currentIndex >= 0
        onTriggered: popupManager.open(detailsDialog, root)
    }
    
    Action {
        id: editAction
        
        text: qsTr("Edit details")
        shortcut: Settings.editStationShortcut
        autoRepeat: false
        enabled: (Settings.token) && (view.currentIndex >= 0)
        && (stationModel.get(view.currentIndex).creatorId == Settings.userId)
        onTriggered: {
            var station = stationModel.get(view.currentIndex);
            popupManager.open(editDialog, root, {stationId: station.id, title: station.title,
                description: station.description, genre: station.genre, country: station.country,
                language: station.language, source: station.source});
        }
    }
    
    Action {
        id: favouriteAction
        
        shortcut: Settings.stationFavouriteShortcut
        autoRepeat: false
        enabled: (Settings.token) && (view.currentIndex >= 0)
        onTriggered: stationModel.get(view.currentIndex).favourite
        ? request.deleteFromFavourites(stationModel.get(view.currentIndex).id)
        : request.addToFavourites(stationModel.get(view.currentIndex).id)
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
            onPressAndHold: popupManager.open(contextMenu, root)
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
    
    Component {
        id: contextMenu
        
        Menu {        
            MenuItem {
                action: detailsAction
            }
            
            MenuItem {
                action: editAction
            }
            
            MenuItem {
                action: favouriteAction
                text: stationModel.get(view.currentIndex).favourite ? qsTr("Delete from favourites")
                : qsTr("Add to favourites")
            }
        }
    }
    
    Component {
        id: detailsDialog
        
        StationDetailsDialog {
            station: stationModel.get(view.currentIndex)
        }
    }
    
    Component {
        id: editDialog

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
