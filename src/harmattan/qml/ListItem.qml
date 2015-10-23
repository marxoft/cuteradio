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

    property bool subItemIndicator: false
    property bool isSelected: false

    signal clicked
    signal pressAndHold

    height: 64 + UI.PADDING_DOUBLE * 2
    width: parent ? parent.width : screen.displayWidth
    opacity: enabled ? UI.OPACITY_ENABLED : UI.OPACITY_DISABLED

    Loader {
        anchors {
            fill: parent
            topMargin: 1
            bottomMargin: 1
        }
        sourceComponent: (mouseArea.pressed) || (root.isSelected) ? highlight : undefined
    }

    Component {
        id: highlight

        Rectangle {
            anchors.fill: parent
            color: root.isSelected ? Settings.activeColor : UI.COLOR_INVERTED_SECONDARY_FOREGROUND
            opacity: 0.5
        }
    }

    Loader {
        anchors {
            right: parent.right
            rightMargin: UI.PADDING_DOUBLE
            verticalCenter: parent.verticalCenter
        }
        sourceComponent: root.subItemIndicator ? indicator : undefined
    }

    Component {
        id: indicator

        Image {
            source: theme.inverted ? "image://theme/icon-m-common-drilldown-arrow-inverse" : "image://theme/icon-m-common-drilldown-arrow"
        }
    }

    MouseArea {
        id: mouseArea

        z: 1
        anchors.fill: parent
        enabled: root.enabled
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }
}
