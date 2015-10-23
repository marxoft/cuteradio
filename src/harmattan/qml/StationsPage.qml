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
import com.nokia.meego 1.0
import CuteRadio 1.0 as CuteRadio
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

MyPage {
    id: root
    
    property alias resource: stationModel.resource
    property alias filters: stationModel.filters
    
    function reload() {
        stationModel.reload();
    }

    tools: ToolBarLayout {

        BackToolIcon {}

        NowPlayingButton {}
        
        ToolIcon {
            anchors.right: parent.right
            platformIconId: "toolbar-refresh"
            onClicked: stationModel.reload()
        }
    }

    ListView {
        id: view

        property int selectedIndex: -1

        anchors.fill: parent
        cacheBuffer: 400
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
                    infoBanner.showMessage(errorString);
                    break;
                default:
                    break;
                }
            
                root.showProgressIndicator = false;
                noResultsLabel.visible = (count == 0);
            }
        }
        delegate: StationDelegate {
            onClicked: player.playStation(stationModel.get(index))
            onPressAndHold: {
                view.selectedIndex = -1;
                view.selectedIndex = index;
                contextMenu.open();
            }
        }
    }

    ScrollDecorator {
        flickableItem: view
    }

    Label {
        id: noResultsLabel
        
        anchors {
            fill: parent
            margins: UI.PADDING_DOUBLE
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
        font.bold: true
        font.pixelSize: 40
        text: qsTr("No stations found")
        visible: false
    }

    ContextMenu {
        id: contextMenu

        MenuLayout {

            MenuItem {
                text: qsTr("Show details")
                onClicked: appWindow.pageStack.push(Qt.resolvedUrl("StationDetailsPage.qml"),
                                                    {station: stationModel.get(view.selectedIndex)})
            }
            
            MenuItem {
                text: qsTr("Edit details")
                visible: (Settings.token) && (stationModel.get(view.selectedIndex).creatorId == Settings.userId)
                onClicked: {
                    loader.sourceComponent = editStationDialog;
                    loader.item.open();
                    
                    var station = stationModel.get(view.selectedIndex);
                    loader.item.title = station.title;
                    loader.item.description = station.description;
                    loader.item.genre = station.genre;
                    loader.item.country = station.country;
                    loader.item.language = station.language;
                    loader.item.source = station.source;
                }
            }

            MenuItem {
                text: stationModel.get(view.selectedIndex).favourite ? qsTr("Delete from favourites")
                                                                     : qsTr("Add to favourites")
                visible: Settings.token != ""
                onClicked: stationModel.get(view.selectedIndex).favourite
                           ? request.deleteFromFavourites(stationModel.get(view.selectedIndex).id)
                           : request.addToFavourites(stationModel.get(view.selectedIndex).id)
            }
        }
    }

    Loader {
        id: loader
    }
    
    Component {
        id: editStationDialog

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
                infoBanner.showMessage(errorString);
                break;
            default:
                break;
            }
            
            root.showProgressIndicator = false;
        }
    }
}
