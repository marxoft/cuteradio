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

Rectangle {
    id: root

    width: screen.width
    height: 26
    color: "black"
    visible: false

    Image {
        id: icon

        source: volumeKeys.volume == 0 ? "images/volume-mute.png" : "images/volume.png"
        smooth: true
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
    }

    ProgressBar {
        id: progressBar

        anchors {
            left: icon.right
            leftMargin: platformStyle.paddingMedium
            right: parent.right
            rightMargin: platformStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
        minimumValue: 0
        maximumValue: 1.0
        value: volumeKeys.volume
    }

    Timer {
        id: timer

        interval: 2000
        onTriggered: root.visible = false
    }

    Connections {
        target: volumeKeys
        onVolumeChanged: {
            root.visible = true;
            timer.restart();
        }
    }
}
