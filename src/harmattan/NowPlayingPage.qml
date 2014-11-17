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
import com.nokia.meego 1.0
import org.marxoft.cuteradio 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

MyPage {
    id: root

    title: player.metaData.title ? player.metaData.title : player.currentStation.title
    tools: ToolBarLayout {

        BackToolIcon {}
    }

    Flickable {
        id: flicker

        anchors {
            left: parent.left
            leftMargin: UI.PADDING_DOUBLE
            right: parent.right
            rightMargin: UI.PADDING_DOUBLE
            top: parent.top
            bottom: controls.top
            bottomMargin: UI.PADDING_DOUBLE
        }
        clip: true
        contentHeight: column.height + UI.PADDING_DOUBLE

        Column {
            id: column

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            spacing: UI.PADDING_DOUBLE

            Item {
                width: parent.width
                height: UI.PADDING_DOUBLE
            }

            Logo {
                width: 120
                height: 120
                source: player.currentStation.logo
                text: player.metaData.title ? player.metaData.title : player.currentStation.title
                enabled: false
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
                font.pixelSize: UI.FONT_SMALL
                text: qsTr("Title") + ": " + (player.metaData.title ? player.metaData.title : player.currentStation.title)
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: UI.FONT_SMALL
                text: qsTr("Artist") + ": " + (player.metaData.artist ? player.metaData.artist : qsTr("Unknown"))
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: UI.FONT_SMALL
                text: qsTr("Genre") + ": " + (player.metaData.genre ? player.metaData.genre : player.currentStation.genre)
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: UI.FONT_SMALL
                text: qsTr("Bitrate") + ": " + (player.metaData.audioBitRate ? Utils.fileSizeFromBytes(player.metaData.audioBitRate) + "/s"
                                                                             : qsTr("Unknown"))
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }

    Column {
        id: controls

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: UI.PADDING_DOUBLE
        }
        spacing: UI.PADDING_XXLARGE

        Rectangle {
            height: 1
            width: parent.width
            color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
            visible: appWindow.inPortrait
        }

        ButtonRow {
            width: parent.width
            exclusive: false

            MyButton {
                height: 100
                iconSource: "image://theme/icon-m-toolbar-mediacontrol-" + (player.playing ? "stop" : "play") + "-white"
                onClicked: player.playing ? player.stop() : player.play()
            }

            MyButton {
                height: 100
                iconSource: "image://theme/icon-m-toolbar-clock-white"
                text: sleepTimer.running ? Utils.durationFromMSecs(sleepTimer.remaining) : ""
                checkable: true
                onClicked: sleepTimer.running = !sleepTimer.running
                Component.onCompleted: checked = sleepTimer.running
            }
        }

        /*MyProgressBar {
            id: progressBar

            width: parent.width
            maximumValue: player.duration
            enabled: player.duration > 0
            value: enabled ? player.position : 0

            SeekBubble {
                id: seekBubble

                anchors.bottom: parent.top
                opacity: value != "" ? 1 : 0
                value: (seekMouseArea.drag.active) && (seekMouseArea.posInsideDragArea) ? Utils.durationFromMSecs(Math.floor((seekMouseArea.mouseX / seekMouseArea.width) * player.duration)) : ""
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
                enabled: player.duration > 0
                onExited: posInsideMouseArea = false
                onEntered: posInsideMouseArea = true
                onPressed: {
                    posInsideMouseArea = true;
                    seekBubble.x = mouseX - 40;
                }
                onReleased: {
                    if (posInsideMouseArea) {
                        player.position = Math.floor((mouseX / width) * player.duration);
                    }
                }
            }
        }*/

        Row {
            Label {
                id: positionLabel

                width: controls.width - durationLabel.width
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: UI.FONT_SMALL
                text: Utils.durationFromMSecs(player.position)
            }

            Label {
                id: durationLabel

                verticalAlignment: Text.AlignVCenter
                font.pixelSize: UI.FONT_SMALL
                text: Utils.durationFromMSecs(player.duration)
                visible: player.duration > 0
            }
        }
        
        Label {
            id: statusLabel
            
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: UI.FONT_SMALL
            text: qsTr("Status") + ": " + (extractor.status == StreamExtractor.Loading ? qsTr("Loading")
                                                                                       : player.bufferProgress < 1
                                                                                       ? qsTr("Buffering")
                                                                                       : player.playing
                                                                                       ? qsTr("Playing")
                                                                                       : qsTr("Stopped"))
        }
    }

    states: State {
        name: "landscape"
        when: !appWindow.inPortrait
        AnchorChanges { target: flicker; anchors { right: parent.horizontalCenter; bottom: parent.bottom } }
        AnchorChanges { target: controls; anchors { left: parent.horizontalCenter; bottom: undefined; verticalCenter: parent.verticalCenter } }
    }
}
