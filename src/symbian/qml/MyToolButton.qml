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

ToolButton {
    id: root

    property string toolTipText

    opacity: enabled ? 1 : 0.5

    ToolTip {
        id: toolTip

        target: root
        text: toolTipText
        visible: false
    }

    Timer {
        interval: 250
        running: (toolTipText) && (root.pressed)
        onTriggered: toolTip.visible = true
    }

    onPressedChanged: if (!pressed) toolTip.visible = false;
}
