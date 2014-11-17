/*
 * Copyright (C) 2014 Stuart Howarth <showarth@marxoft.co.uk>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU Lesser General Public License,
 * version 3, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
 * more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
 */
 
import org.hildon.components 1.0

ItemAction {
    enabled: player.currentStation.id != ""
    item: ValueButton {
        icon: player.playing ? "/etc/hildon/theme/mediaplayer/Play.png"
                             : "/etc/hildon/theme/mediaplayer/Stop.png"
                             
        text: player.currentStation.title
        valueText: (!player.metaData.title) || (player.metaData.title == player.source.substring(player.source.lastIndexOf("/") + 1))
                    ? qsTr("(unknown song)") : player.metaData.title
        onClicked: pageStack.push(Qt.resolvedUrl("NowPlayingPage.qml"), {})
    }
}
