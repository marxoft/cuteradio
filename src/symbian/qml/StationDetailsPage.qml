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

MyPage {
    id: root

    property variant station: {
        "id": "",
        "title": qsTr("Unknown"),
        "description": qsTr("Unknown"),
        "genre": qsTr("Unknown"),
        "country": qsTr("Unknown"),
        "language": qsTr("Unknown"),
        "source": "",
        "favourite": false,
        "lastPlayed": ""
    }

    title: station.title
    tools: ToolBarLayout {

        BackToolButton {}

        NowPlayingButton {}
    }

    MyFlickable {
        id: flicker

        anchors {
            fill: parent
            margins: platformStyle.paddingLarge
        }
        contentHeight: column.height + platformStyle.paddingLarge

        Column {
            id: column

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            spacing: platformStyle.paddingLarge

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: station.description
            }

            SeparatorLabel {
                width: parent.width
                text: qsTr("Properties")
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Genre") + ": " + station.genre
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Country") + ": " + station.country
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Language") + ": " + station.language
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Source") + ": " + station.source
            }

            Label {
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Last played") + ": " + (station.lastPlayed ? station.lastPlayed : qsTr("Never"))
            }
        }
    }

    MyScrollBar {
        flickableItem: flicker
    }
}
