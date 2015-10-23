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

QueryDialog {
    id: root

    function showProgress(info) {
        infoLabel.text = info;
        root.open();
    }

    rejectButtonText: qsTr("Cancel")
    content: Item {
        height: column.height
        anchors {
            left: parent.left
            right: parent.right
        }

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: UI.PADDING_DOUBLE

            Image {
                id: icon

                x: Math.floor((parent.width / 2) - (width / 2))
                source: "images/info.png"
            }

            Label {
                id: infoLabel

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: UI.COLOR_INVERTED_FOREGROUND
            }
        }
    }
}
