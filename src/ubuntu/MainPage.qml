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
import Ubuntu.Components.Popups 1.0
import org.marxoft.cuteradio 1.0

Page {
    id: root
    
    title: "cuteRadio"
    state: "default"
    states: [
        PageHeadState {
            name: "default"
            head: root.head
            actions: [
                Action {
                    text: i18n.tr("Search")
                    iconName: "search"
                    enabled: Settings.token != ""
                    onTriggered: root.state = "search"
                },
                
                SettingsAction {},
                
                PlayUrlAction {},
                
                NowPlayingAction {},
                
                AboutAction {}
            ]
        },
        
        PageHeadState {
            name: "search"
            head: root.head
            actions: Action {                
                text: i18n.tr("Previous searches")
                iconName: "history"
                onTriggered: PopupUtils.open(Qt.resolvedUrl("SearchHistoryDialog.qml"), view)
            }
            backAction: Action {
                text: i18n.tr("Exit search")
                iconName: "back"
                onTriggered: root.state = "default"
            }
            contents: TextField {
                placeholderText: i18n.tr("Search")
                validator: RegExpValidator {
                    regExp: /^.+/
                }
                onVisibleChanged: text = ""
                onAccepted: {
                    if (text) {
                        pageStack.push(Qt.resolvedUrl("SearchPage.qml"), { query: text });
                    }                    
                }
            }
        }
    ]
        
    UbuntuListView {
        id: view
        
        anchors.fill: parent
        model: HomescreenModel {}
        delegate: HomescreenDelegate {
            onClicked: {
                if (!Settings.token) {
                    pageStack.push(Qt.resolvedUrl("AccountPage.qml"));
                }
                else {
                    switch (index) {
                    case 0: {
                        pageStack.push(Qt.resolvedUrl("StationsPage.qml"), { title: i18n.tr("All stations") });
                    
                        if ((stationModel.source != "stations") || (stationModel.count == 0)) {
                            stationModel.source = "stations";
                            stationModel.getStations();
                        }
                    
                        break;
                    }
                    case 1:
                        pageStack.push(Qt.resolvedUrl("GenresPage.qml"), {});
                        break;
                    case 2:
                        pageStack.push(Qt.resolvedUrl("CountriesPage.qml"), {});
                        break;
                    case 3:
                        pageStack.push(Qt.resolvedUrl("LanguagesPage.qml"), {});
                        break;
                    case 4:
                        pageStack.push(Qt.resolvedUrl("RecentlyPlayedPage.qml"), {});
                        break;
                    case 5:
                        pageStack.push(Qt.resolvedUrl("FavouritesPage.qml"), {});
                        break;
                    case 6:
                        pageStack.push(Qt.resolvedUrl("MyStationsPage.qml"), {});
                        break;
                    default:
                        break;
                    }
                }                
            }
        }
    }
    
    Scrollbar {
        id: scrollBar
        
        flickableItem: view
    }
    
    onVisibleChanged: if (!visible) state = "default";
}
