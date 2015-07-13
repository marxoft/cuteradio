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
    
    title: qsTr("Stations by language")
    menuBar: MenuBar {
        NowPlayingMenuItem {}
        
        SleepTimerMenuItem {}
        
        MenuItem {
            text: qsTr("Reload")
            onTriggered: languageModel.getLanguages()
        }
    }

    ListView {
        id: view
        
        anchors.fill: parent
        focus: true
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        model: languageModel
        delegate: NameCountDelegate {
            onClicked: {
                windowStack.push(Qt.resolvedUrl("StationsWindow.qml"), { title: name });
                stationModel.source = "languages$" + name;
                stationModel.getStationsByLanguage(name);
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
        text: qsTr("No languages found")
        visible: false
    }
    
    Connections {
        target: languageModel
        onStatusChanged: {
            switch (languageModel.status) {
            case NameCountModel.Loading: {
                root.showProgressIndicator = true;
                noResultsLabel.visible = false;
                return;
            }
            case NameCountModel.Error:
                informationBox.information(languageModel.errorString);
                break;
            default:
                break;
            }
            
            root.showProgressIndicator = false;
            noResultsLabel.visible = (languageModel.count == 0);
        }
    }
    
    Component.onCompleted: if (languageModel.count == 0) languageModel.getLanguages();
}
