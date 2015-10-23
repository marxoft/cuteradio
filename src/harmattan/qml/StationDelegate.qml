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
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

ListItem {
    id: root

    height: 64 + UI.PADDING_DOUBLE * 2

    Label {
        anchors {
            top: parent.top
            left: parent.left
            right: loader.sourceComponent ? loader.left : parent.right
            margins: UI.PADDING_DOUBLE
        }
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        font.bold: true
        text: title
    }

    Label {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: loader.sourceComponent ? loader.left : parent.right
            margins: UI.PADDING_DOUBLE
        }
        elide: Text.ElideRight
        maximumLineCount: 1
        font.pixelSize: UI.FONT_SMALL
        font.family: UI.FONT_FAMILY_LIGHT
        verticalAlignment: Text.AlignBottom
        color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
        clip: true
        text: genre + " | " + country + " | " + language
    }

    Loader {
        id: loader

        width: 32
        height: 32
        anchors {
            right: parent.right
            rightMargin: UI.PADDING_DOUBLE
            verticalCenter: parent.verticalCenter
        }
        sourceComponent: favourite ? image : undefined
    }

    Component {
        id: image

        Image {
            anchors.fill: parent
            source: "images/favourite-" + Settings.activeColorString + ".png"
        }
    }
}
