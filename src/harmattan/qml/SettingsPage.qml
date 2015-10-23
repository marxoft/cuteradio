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
import CuteRadioApp 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

MyPage {
    id: root

    title: qsTr("Settings")
    tools: ToolBarLayout {

        BackToolIcon {}

        NowPlayingButton {}
    }

    Flickable {
        id: flicker

        anchors.fill: parent
        contentHeight: column.height + UI.PADDING_DOUBLE

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: UI.PADDING_DOUBLE

            ValueSelector {
                width: parent.width
                title: qsTr("Screen orientation")
                model: ScreenOrientationModel {}
                value: Settings.screenOrientation
                onValueChanged: Settings.screenOrientation = value
            }

            Row {
                x: UI.PADDING_DOUBLE
                spacing: UI.PADDING_DOUBLE

                Label {
                    width: column.width - 100 - UI.PADDING_DOUBLE * 3
                    height: UI.FIELD_DEFAULT_HEIGHT
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    text: qsTr("Sleep timer duration (mins)")
                }

                MyTextField {
                    width: 100
                    inputMethodHints: Qt.ImhDigitsOnly
                    maximumLength: 3
                    validator: IntValidator {
                        bottom: 1
                        top: 999
                    }
                    text: Settings.sleepTimerDuration
                    onTextChanged: if (acceptableInput) Settings.sleepTimerDuration = parseInt(text);
                    onAccepted: {
                        platformCloseSoftwareInputPanel();
                        flicker.forceActiveFocus();
                    }
                }
            }
            
            MySwitch {
                id: playedSwitch
                
                text: qsTr("Send played stations data")
                onCheckedChanged: Settings.sendPlayedStationsData = checked
                Component.onCompleted: checked = Settings.sendPlayedStationsData
            }

            Label {
                x: UI.PADDING_DOUBLE
                font.bold: true
                text: qsTr("Active color")
            }

            Flow {
                x: UI.PADDING_DOUBLE
                width: parent.width - UI.PADDING_DOUBLE * 2
                spacing: UI.PADDING_DOUBLE

                Repeater {
                    model: ActiveColorModel {}

                    Rectangle {
                        width: 50
                        height: 50
                        color: value
                        border.color: "white"
                        border.width: color == Settings.activeColor ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Settings.activeColor = value;
                                Settings.activeColorString = "color" + (index + 2).toString();
                            }
                        }
                    }
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
