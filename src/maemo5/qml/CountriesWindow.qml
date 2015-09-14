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
import CuteRadio 1.0 as CuteRadio

Window {
    id: root
    
    function reload() {
        countryModel.reload();
    }
    
    title: qsTr("Stations by country")
    menuBar: MenuBar {
        NowPlayingMenuItem {}
        
        SleepTimerMenuItem {}
        
        MenuItem {
            text: qsTr("Reload")
            onTriggered: countryModel.reload()
        }
    }
    
    ListView {
        id: view

        anchors.fill: parent
        focus: true
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        model: CuteRadio.CountriesModel {
            id: countryModel
            
            onStatusChanged: {
                switch (status) {
                case CuteRadio.ResourcesRequest.Loading: {
                    root.showProgressIndicator = true;
                    noResultsLabel.visible = false;
                    return;
                }
                case CuteRadio.ResourcesRequest.Error:
                    informationBox.information(countryModel.errorString);
                    break;
                default:
                    break;
                }
            
                root.showProgressIndicator = false;
                noResultsLabel.visible = (countryModel.count == 0);
            }
        }
        delegate: NameCountDelegate {
            onClicked: {
                windowStack.push(Qt.resolvedUrl("StationsWindow.qml"), {title: name, filters: {country: name}});
                windowStack.currentWindow.reload();
            }
        }
    }
    
    Label {
        id: noResultsLabel
        
        anchors.fill: view
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: platformStyle.fontSizeLarge
        color: platformStyle.disabledTextColor
        text: qsTr("No countries found")
        visible: false
    }
}
