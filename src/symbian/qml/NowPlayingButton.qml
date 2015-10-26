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

    anchors.centerIn: parent
    flat: false
    iconSource: "images/" + (player.playing ? "play" : "stop") + "-accent-" + ACTIVE_COLOR_STRING + ".png"
    text: player.metaData.title ? player.metaData.title : player.currentStation.title
    visible: player.currentStation.id != ""
    onClicked: appWindow.pageStack.push(Qt.resolvedUrl("NowPlayingPage.qml"))
    onTextChanged: internal.resetButton()
    onVisibleChanged: internal.resetButton()
    onWidthChanged: if (width != 240) internal.resetButton();
    Component.onCompleted: internal.resetButton()

    QtObject {
        id: internal

        function resetButton() {
            root.width = 240;
        }
    }
}
