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

MyListItem {
    id: root

    height: 56 + platformStyle.paddingLarge * 2

    MyListItemText {
        anchors {
            top: parent.top
            left: parent.left
            right: loader.sourceComponent ? loader.left : parent.right
            margins: platformStyle.paddingLarge
        }
        role: "Title"
        mode: root.mode
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        text: title
    }

    MyListItemText {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: loader.sourceComponent ? loader.left : parent.right
            margins: platformStyle.paddingLarge
        }
        role: "SubTitle"
        mode: root.mode
        elide: Text.ElideRight
        verticalAlignment: Text.AlignBottom
        text: genre + " | " + country + " | " + language
    }

    Loader {
        id: loader

        width: 24
        height: 24
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingLarge
            verticalCenter: parent.verticalCenter
        }
        sourceComponent: favourite ? image : undefined
    }

    Component {
        id: image

        Image {
            anchors.fill: parent
            source: "images/favourite-" + ACTIVE_COLOR_STRING + ".png"
            smooth: true
        }
    }
}
