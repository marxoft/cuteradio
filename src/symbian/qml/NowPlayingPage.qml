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
import CuteRadioApp 1.0

MyPage {
    id: root

    title: player.metaData.title ? player.metaData.title : player.currentStation.title
    tools: ToolBarLayout {

        BackToolButton {}
    }

    MyFlickable {
        id: flicker

        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingLarge
            right: parent.right
            rightMargin: platformStyle.paddingLarge
            top: parent.top
            bottom: controls.top
            bottomMargin: platformStyle.paddingLarge
        }
        clip: true
        contentHeight: column.height + platformStyle.paddingLarge

        Column {
            id: column

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            spacing: platformStyle.paddingLarge

            Item {
                width: parent.width
                height: platformStyle.paddingLarge
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: player.metaData.description ? player.metaData.description : player.currentStation.description
            }

            SeparatorLabel {
                width: parent.width
                text: qsTr("Now playing")
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Title") + ": " + (player.metaData.title ? player.metaData.title : player.currentStation.title)
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Artist") + ": " + (player.metaData.artist ? player.metaData.artist : qsTr("Unknown"))
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: platformStyle.fontSizeSmall
                text: qsTr("Genre") + ": " + (player.metaData.genre ? player.metaData.genre : player.currentStation.genre)
            }
        }
    }

    MyScrollBar {
        flickableItem: flicker
    }

    Column {
        id: controls

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: platformStyle.paddingLarge
        }
        spacing: platformStyle.paddingLarge

        Rectangle {
            height: 1
            width: parent.width
            color: platformStyle.colorNormalMid
            visible: appWindow.inPortrait
        }

        ButtonRow {
            width: parent.width
            exclusive: false

            MyButton {
                height: 80
                iconSource: privateStyle.imagePath("toolbar-mediacontrol-" + (player.playing ? "stop" : "play"), platformInverted)
                onClicked: player.playing ? player.stop() : player.restart()
            }

            MyButton {
                height: 80
                iconSource: "images/clock.png"
                text: sleepTimer.running ? Utils.formatMSecs(sleepTimer.remaining) : ""
                checkable: true
                onClicked: sleepTimer.running = !sleepTimer.running
                Component.onCompleted: checked = sleepTimer.running
            }
        }

        /*ProgressBar {
            id: progressBar

            width: parent.width
            maximumValue: (MediaPlayer.duration > 0) ? MediaPlayer.duration : 100
            enabled: MediaPlayer.duration > 0
            value: enabled ? MediaPlayer.position : 0

            SeekBubble {
                id: seekBubble

                anchors.bottom: parent.top
                opacity: value != "" ? 1 : 0
                value: (seekMouseArea.drag.active) && (seekMouseArea.posInsideDragArea) ? Utils.formatMSecs(Math.floor((seekMouseArea.mouseX / seekMouseArea.width) * MediaPlayer.duration)) : ""
            }

            MouseArea {
                id: seekMouseArea

                property bool posInsideMouseArea: false
                property bool posInsideDragArea: (seekMouseArea.mouseX >= 0) && (seekMouseArea.mouseX <= seekMouseArea.drag.maximumX)

                width: parent.width
                height: 60
                anchors.centerIn: parent
                drag.target: seekBubble
                drag.axis: Drag.XAxis
                drag.minimumX: -40
                drag.maximumX: width - 10
                enabled: MediaPlayer.duration > 0
                onExited: posInsideMouseArea = false
                onEntered: posInsideMouseArea = true
                onPressed: {
                    posInsideMouseArea = true;
                    seekBubble.x = mouseX - 40;
                }
                onReleased: {
                    if (posInsideMouseArea) {
                        MediaPlayer.position = Math.floor((mouseX / width) * MediaPlayer.duration);
                    }
                }
            }
        }*/

        Row {
            Label {
                id: positionLabel

                width: controls.width - durationLabel.width
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: platformStyle.fontSizeSmall
                text: symbian.foreground ? Utils.formatMSecs(player.position) : ""
            }

            Label {
                id: durationLabel

                verticalAlignment: Text.AlignVCenter
                font.pixelSize: platformStyle.fontSizeSmall
                text: Utils.formatMSecs(player.duration)
                visible: player.duration > 0
            }
        }
        
        Label {
            id: statusLabel
            
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: platformStyle.fontSizeSmall
            text: qsTr("Status") + ": " + (extractor.status == StreamExtractor.Loading ? qsTr("Loading")
                                                                                       : !player.playing
                                                                                       ? qsTr("Stopped")
                                                                                       : player.bufferProgress < 1
                                                                                       ? qsTr("Buffering")
                                                                                       : qsTr("Playing"))
        }
    }

    states: State {
        name: "landscape"
        when: !appWindow.inPortrait
        
        AnchorChanges {
            target: flicker
            anchors {
                right: parent.horizontalCenter
                bottom: parent.bottom
            }
        }
        
        AnchorChanges {
            target: controls
            anchors {
                left: parent.horizontalCenter
                bottom: undefined
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
