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
        icon: "general_clock"
        text: qsTr("Sleep timer")
        valueText: sleepTimer.running ? Utils.durationFromMSecs(sleepTimer.remaining) : qsTr("Off")
        checkable: true
        checked: sleepTimer.running
        onClicked: {
            sleepTimer.running = !sleepTimer.running;
            infobox.showMessage(sleepTimer.running ? qsTr("Sleep timer set for")
                                                     + " " + Settings.sleepTimerDuration + " " + qsTr("minutes")
                                                   : qsTr("Sleep timer disabled"));
        }
    }
}
