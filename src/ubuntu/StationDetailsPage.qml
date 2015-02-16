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

    property variant station: {
        "id": "",
        "title": i18n.tr("Unknown"),
        "description": i18n.tr("Unknown"),
        "genre": i18n.tr("Unknown"),
        "country": i18n.tr("Unknown"),
        "language": i18n.tr("Unknown"),
        "logo": "",
        "source": "",
        "is_favourite": false,
        "favourite_id": "",
        "last_played": ""
    }

    title: station.title
    head.actions: [
        Action {
            iconName: "edit"
            text: i18n.tr("Edit station")
            visible: stationModel.source == "mystations"
            onTriggered: pageStack.push(addStationPage).station = station
        },
    
        SettingsAction {},
        
        PlayUrlAction {},
        
        NowPlayingAction {}
    ]

    Flickable {
        id: flicker

        anchors.fill: parent
        contentHeight: column.height + units.gu(1)

        Column {
            id: column

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(1)
            }
            spacing: units.gu(1)

            Logo {
                width: 120
                height: 120
                source: station.logo
                text: station.title
                enabled: player.currentStation.id != station.id
                onClicked: player.playStation(station)
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.description
            }

            SeparatorLabel {
                width: parent.width
                text: i18n.tr("Properties")
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                fontSize: "small"
                text: i18n.tr("Genre") + ": " + station.genre
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                fontSize: "small"
                text: i18n.tr("Country") + ": " + station.country
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                fontSize: "small"
                text: i18n.tr("Language") + ": " + station.language
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                fontSize: "small"
                text: i18n.tr("Source") + ": " + station.source
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                fontSize: "small"
                text: i18n.tr("Last played") + ": " + (station.last_played ? station.last_played : i18n.tr("Never"))
            }
        }
    }

    Scrollbar {
        flickableItem: flicker
    }

    Component {
        id: addStationPage

        AddStationPage {
            onResultChanged: {
                if (result) {
                    root.station = result;
                    stationModel.setItemData(stationModel.match("id", stationId), result);
                    infoBanner.showMessage(i18n.tr("Station updated"));
                }
            }
        }
    }
}
