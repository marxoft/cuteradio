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

Item {
    id: root

    property alias text: title.text
    property alias checked: switcher.checked

    signal checkedChanged

    width: parent.width
    height: 84

    Label {
        id: title

        anchors {
            left: parent.left
            leftMargin: UI.PADDING_DOUBLE
            right: switcher.left
            rightMargin: UI.PADDING_DOUBLE
            verticalCenter: parent.verticalCenter
        }

        font.bold: true
        verticalAlignment: Text.AlignVCenter
        maximumLineCount: 2
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
    }

    Switch {
        id: switcher

        platformStyle: SwitchStyle {
            switchOn: "image://theme/" + Settings.activeColorString + "-meegotouch-switch-on" + __invertedString
        }

        anchors {
            right: parent.right
            rightMargin: UI.PADDING_DOUBLE
            verticalCenter: parent.verticalCenter
        }

        onCheckedChanged: root.checkedChanged()
    }
}
