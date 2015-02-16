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
import Ubuntu.Components 1.1
import org.marxoft.cuteradio 1.0

Page {
    id: root
    
    title: i18n.tr("My stations")
    head.actions: [
        Action {
            iconName: "add"
            text: i18n.tr("New station")
            onTriggered: pageStack.push(addStationPage)
        },
        
        SettingsAction {},
        
        PlayUrlAction {},
        
        NowPlayingAction {}
    ]

    UbuntuListView {
        id: view

        anchors.fill: parent
        cacheBuffer: 400
        model: stationModel
        pullToRefresh.enabled: true
        delegate: StationDelegate {
            menuItems: [
                { text: i18n.tr("Play"), iconName: "media-playback-start" },
                { text: i18n.tr("Show details"), iconName: "info" },
                { text: i18n.tr("Edit details"), iconName: "edit" },
                { text: i18n.tr("Delete from 'My stations'"), iconName: "delete" }
            ]
            onClicked: view.expandedIndex = (view.expandedIndex == index ? -1 : index)
            onMenuItemClicked: {
                switch (menuIndex) {
                case 0:
                    player.playStation(stationModel.itemData(index));
                    break;
                case 1:
                    pageStack.push(Qt.resolvedUrl("StationDetailsPage.qml"),
                                   { station: stationModel.itemData(index) });
                    break;
                case 2: {
                    var page = pageStack.push(addStationPage);
                    page.station = stationModel.itemData(index);
                    page.mode = "edit";
                    break;
                }
                case 3:
                    request.deleteFromMyStations(id);
                    break;
                default:
                    break;
                }
                
                view.expandedIndex = -1;
            }    
        }
        section.delegate: SectionDelegate {
            text: section
        }
        section.property: "updated_section"
        section.criteria: ViewSection.FullString
    }

    Scrollbar {
        id: scrollBar
        
        flickableItem: view
    }

    Label {
        id: noResultsLabel
        
        anchors {
            fill: parent
            margins: units.gu(1)
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        text: i18n.tr("No stations found")
        visible: false
    }
    
    Component {
        id: addStationPage

        AddStationPage {
            onResultChanged: {
                if (result) {
                    if (mode == "edit") {
                        stationModel.setItemData(stationModel.match("id", station.id), result);
                        infoBanner.showMessage(i18n.tr("Station updated"));
                    }
                    else {
                        stationModel.insertItem(0, result);
                    }
                }
            }
        }
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
                view.enabled = false;
                return;
            case CuteRadioRequest.Ready: {
                stationModel.removeItem(stationModel.match("id", stationId));
                noResultsLabel.visible = (stationModel.count == 0);
                break;
            }
            case CuteRadioRequest.Error:
                infoBanner.showMessage(errorString);
                break;
            default:
                break;
            }
            
            view.enabled = true;
        }
    }
    
    Connections {
        target: stationModel
        onStatusChanged: {
            switch (stationModel.status) {
            case StationModel.Loading: {
                view.pullToRefresh.refreshing = true;
                noResultsLabel.visible = false;
                return;
            }
            case StationModel.Error:
                infoBanner.showMessage(stationModel.errorString);
                break;
            default:
                break;
            }
            
            view.pullToRefresh.refreshing = false;
            noResultsLabel.visible = (stationModel.count == 0);
        }
    }
    
    Connections {
        target: view.pullToRefresh
        onRefresh: stationModel.getMyStations()
    }
    
    Component.onCompleted: {
        if ((stationModel.source != "mystations") || (stationModel.count == 0)) {
            stationModel.source = "mystations";
            stationModel.getMyStations();
        }
    }
}
