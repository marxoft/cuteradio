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
    
    property string query

    title: i18n.tr("Search") + " ('" + query + "')"
    head.actions: [
        SettingsAction {},
        
        PlayUrlAction {},
        
        NowPlayingAction {}
    ]
    
    ActionList {
        id: delegateActions
        
        Action {
            text: i18n.tr("Play")
            iconName: "media-playback-start"
            onTriggered: player.playStation(stationModel.itemData(view.expandedIndex))
        }
        
        Action {
            text: i18n.tr("Show details")
            iconName: "info"
            onTriggered: pageStack.push(Qt.resolvedUrl("StationDetailsPage.qml"),
                                        { station: stationModel.itemData(view.expandedIndex) })
        }
        
        Action {
            text: stationModel.data(view.expandedIndex, "is_favourite") ? i18n.tr("Delete from favourites")
                                                                        : i18n.tr("Add to favourites")
            iconName: stationModel.data(view.expandedIndex, "is_favourite") ? "non-starred" : "starred"
            onTriggered: stationModel.data(view.expandedIndex, "is_favourite") 
                        ? request.deleteFromFavourites(stationModel.data(view.expandedIndex, "favourite_id"))
                        : request.addToFavourites(stationModel.data(view.expandedIndex, "id"))
        }
        
        Action {
            text: i18n.tr("Add to 'My stations'")
            iconName: "add"
            onTriggered: pageStack.push(addStationPage).station = stationModel.itemData(view.expandedIndex)
        }
    }

    UbuntuListView {
        id: view

        anchors.fill: parent
        cacheBuffer: 400
        model: stationModel
        pullToRefresh.enabled: true
        delegate: StationDelegate {
            actions: delegateActions.actions
            onClicked: view.expandedIndex = (view.expandedIndex == index ? -1 : index)  
        }
        section.delegate: SectionDelegate {
            text: section
        }
        section.property: "title_section"
        section.criteria: ViewSection.FirstCharacter
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
            onResultChanged: if (result) infoBanner.showMessage(i18n.tr("Station added to 'My stations'"));
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
        
        authRequired: true
        onStatusChanged: {
            switch (status) {
            case CuteRadioRequest.Loading:
                view.enabled = false;
                return;
            case CuteRadioRequest.Ready: {
                if (result.id) {
                    stationModel.setItemData(stationModel.match("id", stationId), result);
                }
                else {
                    stationModel.setData(stationModel.match("favourite_id", stationId), false, "is_favourite");
                }
                
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
        onRefresh: stationModel.searchStations(root.query)
    }
    
    Component.onCompleted: {
        stationModel.source = "search$" + root.query;
        stationModel.searchStations(root.query);
    }
}
