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

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-settings"
            onClicked: appWindow.pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
        }

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
                text: qsTr("About")
                onClicked: {
                    loader.sourceComponent = aboutDialog;
                    loader.item.open();
                }
            }
        }
    }

    SearchBox {
        id: searchBox

        z: Number.MAX_VALUE
        placeholderText: qsTr("Search")
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        enabled: Settings.token != ""
        onSearchTextChanged: if (!searchText) view.focus = true;
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

    ListView {
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
    }

    ScrollDecorator {
        flickableItem: view
    }

    Loader {
        id: loader
    }

    Component {
        id: searchDialog

        SearchHistoryDialog {}
    }

    Component {
        id: urlDialog

        PlayUrlDialog {}
    }
    
    Component {
        id: accountDialog
        
        AccountDialog {}
    }

    Component {
        id: aboutDialog

        AboutDialog {}
    }
}
