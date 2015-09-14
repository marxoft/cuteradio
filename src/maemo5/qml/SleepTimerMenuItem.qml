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
    
    enabled: player.currentStation.id != ""
    
    ValueButton {
        iconName: "general_clock"
        text: qsTr("Sleep timer")
        valueText: sleepTimer.running ? Utils.formatMSecs(sleepTimer.remaining) : qsTr("Off")
        checkable: true
        checked: sleepTimer.running
        onClicked: {
            sleepTimer.running = !sleepTimer.running;
            informationBox.information(sleepTimer.running ? qsTr("Sleep timer set for")
                                       + " " + Settings.sleepTimerDuration + " " + qsTr("minutes")
                                       : qsTr("Sleep timer disabled"));
        }
    }
}
