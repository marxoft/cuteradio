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

import QtQuick 1.0
import org.hildon.components 1.0

MenuItem {
    id: root
    
    enabled: nowPlayingAction.enabled
    
    ValueButton {        
        action: nowPlayingAction
        valueText: (!player.metaData.title)
        || (player.metaData.title == player.source.substring(player.source.lastIndexOf("/") + 1))
        ? qsTr("(unknown song)") : player.metaData.title
    }
}
