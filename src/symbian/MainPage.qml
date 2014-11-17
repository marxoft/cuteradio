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

    tools: ToolBarLayout {

        BackToolButton {
            id: backButton
        }

        NowPlayingButton {}

        MyToolButton {
            iconSource: "toolbar-view-menu"
            toolTipText: qsTr("Menu")
            onClicked: menu.open()
        }
    }

    Menu {
        id: menu

        MenuLayout {

            MenuItem {
                text: qsTr("Play URL")
                onClicked: {
                    loader.sourceComponent = urlDialog;
                    loader.item.open();
                }
            }

            MenuItem {
                text: qsTr("Account")
                visible: Settings.token == ""
                onClicked: {
                    loader.sourceComponent = accountDialog;
                    loader.item.open();
                }
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: appWindow.pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            
            MenuItem {
                text: qsTr("Update")
                onClicked: updateManager.checkForUpdate()
            }

            MenuItem {
                text: qsTr("About")
                onClicked: {
                    loader.sourceComponent = aboutDialog;
                    loader.item.open();
                }
            }
        }

        onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
    }

    MySearchBox {
        id: searchBox

        z: Number.MAX_VALUE
        placeHolderText: qsTr("Search")
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        enabled: Settings.token != ""
        onSearchTextChanged: if (!searchText) view.forceActiveFocus();
        onMenuTriggered: {
            loader.sourceComponent = searchDialog;
            loader.item.open();
        }
        onAccepted: {
            if (searchText) {
                var query = searchText;
                searchText = "";
                appWindow.pageStack.push(Qt.resolvedUrl("SearchPage.qml"), { query: query });
            }
        }
    }

    MyListView {
        id: view

        anchors {
            left: parent.left
            right: parent.right
            top: searchBox.bottom
            bottom: parent.bottom
        }
        model: HomescreenModel {
            id: homescreenModel
        }
        delegate: DrillDownDelegate {
            onClicked: {
                if (!Settings.token) {
                    infoBanner.showMessage(qsTr("Please login or register a cuteRadio account"));
                    loader.sourceComponent = accountDialog;
                    loader.item.open();
                }
                else {
                    switch (index) {
                    case 0: {
                        appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"), { title: qsTr("All stations") });

                        if ((stationModel.source != "stations") || (stationModel.count == 0)) {
                            stationModel.source = "stations";
                            stationModel.getStations();
                        }

                        break;
                    }
                    case 1:
                        appWindow.pageStack.push(Qt.resolvedUrl("GenresPage.qml"));
                        break;
                    case 2:
                        appWindow.pageStack.push(Qt.resolvedUrl("CountriesPage.qml"));
                        break;
                    case 3:
                        appWindow.pageStack.push(Qt.resolvedUrl("LanguagesPage.qml"));
                        break;
                    case 4:
                        appWindow.pageStack.push(Qt.resolvedUrl("RecentlyPlayedPage.qml"));
                        break;
                    case 5:
                        appWindow.pageStack.push(Qt.resolvedUrl("FavouritesPage.qml"));
                        break;
                    case 6:
                        appWindow.pageStack.push(Qt.resolvedUrl("MyStationsPage.qml"));
                        break;
                    default:
                        break;
                    }
                }
            }
        }

        Keys.forwardTo: searchBox
    }

    MyScrollBar {
        flickableItem: view
    }

    Loader {
        id: loader
    }

    Component {
        id: searchDialog

        SearchHistoryDialog {
            onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
        }
    }

    Component {
        id: urlDialog

        PlayUrlDialog {
            onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
        }
    }

    Component {
        id: accountDialog

        AccountDialog {
            onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
        }
    }

    Component {
        id: aboutDialog

        AboutDialog {
            onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
        }
    }
}
