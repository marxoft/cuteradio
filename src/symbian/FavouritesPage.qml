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
import com.nokia.symbian 1.1
import org.marxoft.cuteradio 1.0

MyPage {
    id: root

    title: qsTr("Favourite stations")
    tools: ToolBarLayout {

        BackToolButton {}

        NowPlayingButton {}

        MyToolButton {
            anchors.right: parent.right
            iconSource: "toolbar-refresh"
            toolTipText: qsTr("Reload")
            onClicked: stationModel.getFavouriteStations()
        }
    }

    MyListView {
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
            margins: platformStyle.paddingLarge
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        color: platformStyle.colorNormalMid
        font.bold: true
        font.pixelSize: 32
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
                text: qsTr("Delete from favourites")
                onClicked: request.deleteFromFavourites(stationModel.data(view.selectedIndex, "favourite_id"))
            }

            MenuItem {
                text: qsTr("Add to 'My stations'")
                onClicked: {
                    var station = stationModel.itemData(view.selectedIndex);
                    loader.sourceComponent = addStationDialog;
                    loader.item.open();
                    loader.item.title = station.title;
                    loader.item.description = station.description;
                    loader.item.genre = station.genre;
                    loader.item.country = station.country;
                    loader.item.language = station.language;
                    loader.item.logo = station.logo;
                    loader.item.source = station.source;
                }
            }
        }

        onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
    }

    Loader {
        id: loader
    }

    Component {
        id: addStationDialog

        AddStationDialog {
            onAccepted: infoBanner.showMessage(qsTr("Station added to 'My stations'"));
            onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
        }
    }

    CuteRadioRequest {
        id: request

        property string stationId

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
                    infoBanner.showMessage(qsTr("Station added to 'My stations'"));
                }
                else {
                    stationModel.removeItem(stationModel.match("favourite_id", stationId));
                    noResultsLabel.visible = (stationModel.count == 0);
                }

                break;
            }
            case CuteRadioRequest.Error:
                infoBanner.showMessage(errorString);
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
        if ((stationModel.source != "favourites") || (stationModel.count == 0)) {
            stationModel.source = "favourites";
            stationModel.getFavouriteStations();
        }
    }
}
