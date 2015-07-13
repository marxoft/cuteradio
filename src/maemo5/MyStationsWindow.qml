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
    
    title: qsTr("My stations")
    menuBar: MenuBar {
        NowPlayingMenuItem {}
        
        SleepTimerMenuItem {}
        
        MenuItem {
            text: qsTr("Reload")
            onTriggered: stationModel.getMyStations()
        }
        
        MenuItem {
            text: qsTr("Add station")
            onTriggered: dialogs.showAddStationDialog()
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
            text: qsTr("Edit details")
            onTriggered: dialogs.showAddStationDialog()
        }
        
        MenuItem {
            text: qsTr("Delete from 'My stations'")
            onTriggered: request.deleteFromMyStations(stationModel.data(view.currentIndex, "id"))
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
        id: addStationDialogComponent
        
        AddStationDialog {
             onAccepted: {
                if (stationId) {
                    stationModel.setItemData(stationModel.match("id", stationId), result);
                    informationBox.information(qsTr("Station updated"));
                }
                else {
                    stationModel.insertItem(0, result);
                }
            }
        }
    }
    
    Component {
        id: detailsDialogComponent
        
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
        if ((stationModel.source != "mystations") || (stationModel.count == 0)) {
            stationModel.source = "mystations";
            stationModel.getMyStations();
        }
    }
}
