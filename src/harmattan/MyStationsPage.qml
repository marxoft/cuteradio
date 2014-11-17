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

import QtQuick 1.1
import com.nokia.meego 1.0
import org.marxoft.cuteradio 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

MyPage {
    id: root

    title: qsTr("My stations")
    tools: ToolBarLayout {

        BackToolIcon {}

        NowPlayingButton {}
        
        ToolIcon {
            anchors.right: parent.right
            platformIconId: "toolbar-view-menu"
            onClicked: menu.open()
        }
    }

    Menu {
        id: menu

        MenuLayout {

            MenuItem {
                text: qsTr("Reload")
                onClicked: stationModel.getMyStations()
            }

            MenuItem {
                text: qsTr("Add station")
                onClicked: {
                    loader.sourceComponent = addStationDialog;
                    loader.item.open();
                }
            }
        }
    }

    ListView {
        id: view

        property int selectedIndex: -1

        anchors.fill: parent
        cacheBuffer: 400
        model: stationModel
        delegate: StationDelegate {
            onClicked: player.playStation(stationModel.itemData(index))
            onPressAndHold: {
                if (request.status != CuteRadioRequest.Loading) {
                    view.selectedIndex = -1;
                    view.selectedIndex = index;
                    contextMenu.open();
                }
            }
        }
        section.delegate: SectionDelegate {
            text: section
        }
        section.property: "updated_section"
        section.criteria: ViewSection.FullString
    }

    MySectionScroller {
        listView: view
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
                                                    { station: stationModel.itemData(view.selectedIndex) })
            }

            MenuItem {
                text: qsTr("Edit details")
                onClicked: {
                    var station = stationModel.itemData(view.selectedIndex);
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
                }
            }

            MenuItem {
                text: qsTr("Delete from 'My stations'")
                onClicked: request.deleteFromMyStations(stationModel.data(view.selectedIndex, "id"))
            }
        }
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
                    infoBanner.showMessage(qsTr("Station updated"));
                }
                else {
                    stationModel.insertItem(0, result);
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
                root.showProgressIndicator = true;
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
            
            root.showProgressIndicator = false;
            noResultsLabel.visible = (stationModel.count == 0);
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
                infoBanner.showMessage(stationModel.errorString);
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
