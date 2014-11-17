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

import QtQuick 1.1
import com.nokia.symbian 1.1
import org.marxoft.cuteradio 1.0

MyPage {
    id: root

    title: qsTr("Settings")
    tools: ToolBarLayout {

        BackToolButton {}

        NowPlayingButton {}
    }

    KeyNavFlickable {
        id: flicker

        anchors.fill: parent
        contentHeight: inputContext.visible ? height : column.height + platformStyle.paddingLarge

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            ValueSelector {
                width: parent.width
                title: qsTr("Screen orientation")
                model: ScreenOrientationModel {}
                value: Settings.screenOrientation
                onValueChanged: Settings.screenOrientation = value
                visible: !inputContext.visible
            }

//            ValueSelector {
//                width: parent.width
//                title: qsTr("Language")
//                model: LanguageModel {}
//                value: Settings.language
//                onValueChanged: Settings.language = value
//                visible: !inputContext.visible
//            }

            Item {
                width: parent.width
                height: platformStyle.paddingLarge
            }

            Row {
                x: platformStyle.paddingLarge
                spacing: platformStyle.paddingLarge

                Label {
                    width: column.width - 60 - platformStyle.paddingLarge * 3
                    height: sleepTimerField.height
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Sleep timer duration (mins)")
                    visible: sleepTimerField.visible
                }

                MyTextField {
                    id: sleepTimerField

                    width: 60
                    inputMethodHints: Qt.ImhDigitsOnly
                    maximumLength: 3
                    validator: IntValidator {
                        bottom: 1
                        top: 999
                    }
                    text: Settings.sleepTimerDuration
                    visible: (!inputContext.visible) || (focus)
                    onTextChanged: if (acceptableInput) Settings.sleepTimerDuration = parseInt(text);
                    onAccepted: {
                        closeSoftwareInputPanel();
                        flicker.forceActiveFocus();
                    }
                }
            }

            Item {
                width: parent.width
                height: platformStyle.paddingLarge
                visible: !inputContext.visible
            }

            MySwitch {
                id: playedSwitch

                width: parent.width
                text: qsTr("Send played stations data")
                visible: !inputContext.visible
                Component.onCompleted: checked = Settings.sendPlayedStationsData
                onCheckedChanged: Settings.sendPlayedStationsData = checked
            }
        }
    }

    MyScrollBar {
        flickableItem: flicker
    }
}
