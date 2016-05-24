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
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import CuteRadioApp 1.0

MyPage {
    id: root

    title: "cuteRadio"
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
                text: qsTr("Add station")
                visible: Settings.token != ""
                onClicked: {
                    loader.sourceComponent = addStationDialog;
                    loader.item.open();
                }
            }

            MenuItem {
                text: qsTr("Sign in/create account")
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

    SearchBox {
        id: searchBox

        z: Number.MAX_VALUE
        placeHolderText: qsTr("Search")
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        onSearchTextChanged: if (!searchText) view.forceActiveFocus();
        Keys.onEnterPressed: {
            if (searchText) {
                var query = searchText;
                searchText = "";
                appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"),
                {title: qsTr("Search") + " ('" + query + "')", filters: {search: query}});
                appWindow.pageStack.currentPage.reload();
            }
        }
    }

    Image {
        z: Number.MAX_VALUE
        visible: appWindow.cornersVisible
        anchors.top : parent.top
        anchors.left: parent.left
        source: "images/corner-left.png"
    }

    Image {
        z: Number.MAX_VALUE
        visible: appWindow.cornersVisible
        anchors.top: parent.top
        anchors.right: parent.right
        source: "images/corner-right.png"
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
                switch (index) {
                case 0:
                    appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"), {title: name});
                    break;
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
                    appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"), {title: name, resource: "playedstations"});
                    break;
                case 5:
                    appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"), {title: name, resource: "favourites"});
                    break;
                case 6:
                    appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"), {title: name, filters: {mine: true}});
                    break;
                default:
                    break;
                }
                
                appWindow.pageStack.currentPage.reload();
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
        id: urlDialog

        PlayUrlDialog {
            onStatusChanged: if ((status === DialogStatus.Closed) && (root.status === PageStatus.Active)) view.forceActiveFocus();
        }
    }
    
    Component {
        id: addStationDialog
        
        AddStationDialog {
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
