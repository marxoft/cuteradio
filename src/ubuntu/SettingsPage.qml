/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
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

import QtQuick 2.2
import Ubuntu.Components 1.1
import org.marxoft.cuteradio 1.0

Page {
    id: root

    title: i18n.tr("Settings")

    Flickable {
        id: flicker

        anchors.fill: parent
        contentHeight: column.height + units.gu(1)

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: units.gu(1)
            }
            spacing: units.gu(1)

            Row {
                spacing: units.gu(1)

                Label {
                    height: sleepTimerField.height
                    width: column.width - sleepTimerField.width - units.gu(1)
                    verticalAlignment: Text.AlignVCenter
                    text: i18n.tr("Sleep timer duration (mins)")
                }

                TextField {
                    id: sleepTimerField
                    
                    width: playedSwitch.width
                    inputMethodHints: Qt.ImhDigitsOnly
                    maximumLength: 3
                    validator: IntValidator {
                        bottom: 1
                        top: 999
                    }
                    text: Settings.sleepTimerDuration
                    onTextChanged: if (acceptableInput) Settings.sleepTimerDuration = parseInt(text);
                }
            }
            
            Row {
                spacing: units.gu(1)

                Label {
                    height: playedSwitch.height
                    width: column.width - playedSwitch.width - units.gu(1)
                    verticalAlignment: Text.AlignVCenter
                    text: i18n.tr("Send played stations data")
                }

                Switch {
                    id: playedSwitch
                
                    checked: Settings.sendPlayedStationsData
                    onClicked: Settings.sendPlayedStationsData = checked
                }
            }
            
            Row {
                spacing: units.gu(1)

                Label {
                    height: orientationSwitch.height
                    width: column.width - orientationSwitch.width - units.gu(1)
                    verticalAlignment: Text.AlignVCenter
                    text: i18n.tr("Lock screen orientation")
                }

                Switch {
                    id: orientationSwitch

                    checked: Settings.screenOrientation != 0
                    onClicked: Settings.screenOrientation = (checked ? 1 : 0)
                }
            }
        }
    }

    Scrollbar {
        flickableItem: flicker
    }
}
