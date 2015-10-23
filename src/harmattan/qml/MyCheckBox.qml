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

CheckBox {
    id: root

    platformStyle: CheckBoxStyle {
        backgroundPressed: "image://theme/" + Settings.activeColorString + "-meegotouch-button-checkbox" + __invertedString + "-background-pressed"
        backgroundSelected: "image://theme/" + Settings.activeColorString + "-meegotouch-button-checkbox" + __invertedString + "-background-selected"
    }

    MouseArea {
        z: root.enabled ? -1 : 10
        anchors.fill: parent
        enabled: !root.enabled
    }
}
