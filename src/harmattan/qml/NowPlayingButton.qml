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

ToolButton {
    id: button

    platformStyle: ToolButtonStyle {
        textColor: Settings.activeColor
    }
    width: 300
    anchors.centerIn: parent
    iconSource: "images/" + (player.playing ? "play" : "stop") + "-accent-" + Settings.activeColorString + ".png"
    text: player.metaData.title ? player.metaData.title : player.currentStation.title
    visible: player.currentStation.id != ""
    onClicked: appWindow.pageStack.push(Qt.resolvedUrl("NowPlayingPage.qml"))
}
