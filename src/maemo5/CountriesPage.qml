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
 
import org.hildon.components 1.0
import org.marxoft.cuteradio 1.0

Page {
    id: root
    
    windowTitle: qsTr("Stations by country")
    tools: [
        NowPlayingAction {},
        
        SleepTimerAction {},
        
        Action {
            text: qsTr("Reload")
            onTriggered: countryModel.getCountries()
        }
    ]
    
    actions: Action {
        shortcut: "Ctrl+R"
        onTriggered: countryModel.getCountries()
    }
    
    ListView {
        id: view

        anchors.fill: parent
        focusPolicy: Qt.NoFocus
        horizontalScrollMode: ListView.ScrollPerItem
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        model: countryModel
        delegate: NameCountDelegate {}
        onClicked: {
            var name = countryModel.data(QModelIndex.row(currentIndex), "name");
            pageStack.push(Qt.resolvedUrl("StationsPage.qml"), { windowTitle: name });
            stationModel.source = "countries$" + name;
            stationModel.getStationsByCountry(name);
            currentIndex = QModelIndex.parent(currentIndex);
        }
    }
    
    Label {
        id: noResultsLabel
        
        anchors.fill: view
        alignment: Qt.AlignCenter
        font.pixelSize: platformStyle.fontSizeLarge
        color: platformStyle.disabledTextColor
        text: qsTr("No countries found")
        visible: false
    }
    
    Connections {
        target: countryModel
        onStatusChanged: {
            switch (countryModel.status) {
            case NameCountModel.Loading: {
                root.showProgressIndicator = true;
                noResultsLabel.visible = false;
                return;
            }
            case NameCountModel.Error:
                infobox.showError(countryModel.errorString);
                break;
            default:
                break;
            }
            
            root.showProgressIndicator = false;
            noResultsLabel.visible = (countryModel.count == 0);
        }
    }
    
    Component.onCompleted: if (countryModel.count == 0) countryModel.getCountries();
}
