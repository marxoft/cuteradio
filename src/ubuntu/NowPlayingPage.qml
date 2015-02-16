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
import QtMultimedia 5.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0
import org.marxoft.cuteradio 1.0

Page {
    id: root

    title: player.metaData.title ? player.metaData.title : player.currentStation.title
    head.actions: [		
		SettingsAction {},
        
        PlayUrlAction {}      
    ]

    Flickable {
        id: flicker

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: controls.top
            bottomMargin: units.gu(1)
        }
        clip: true
        contentHeight: column.height + units.gu(1)

        Column {
            id: column

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(1)
            }
            spacing: units.gu(1)

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
                text: i18n.tr("Now playing")
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                fontSize: "small"
                text: i18n.tr("Title") + ": " + (player.metaData.title ? player.metaData.title : player.currentStation.title)
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                fontSize: "small"
                text: i18n.tr("Artist") + ": " + (player.metaData.artist ? player.metaData.artist : i18n.tr("Unknown"))
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                fontSize: "small"
                text: i18n.tr("Genre") + ": " + (player.metaData.genre ? player.metaData.genre : player.currentStation.genre)
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                fontSize: "small"
                text: i18n.tr("Bitrate") + ": " + (player.metaData.audioBitRate ? Utils.fileSizeFromBytes(player.metaData.audioBitRate) + "/s"
                                                                             : i18n.tr("Unknown"))
            }
        }
    }

    Scrollbar {
        flickableItem: flicker
    }

    Column {
        id: controls

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: units.gu(1)
        }
        spacing: units.gu(2)

        ThinDivider {
            width: parent.width
            visible: root.height > root.width
        }

        Row {
            spacing: units.gu(1)

            Button {
                width: Math.floor((controls.width - units.gu(1)) / 2)
                height: units.gu(10)
                iconName: player.playbackState == Audio.PlayingState ? "media-playback-stop" : "media-playback-start"
                color: player.playbackState == Audio.PlayingState ? UbuntuColors.red : UbuntuColors.green
                onClicked: player.playbackState == Audio.PlayingState ? player.stop() : player.restart()
            }

            Button {
                width: Math.floor((controls.width - units.gu(1)) / 2)
                height: units.gu(10)
                iconName: "alarm-clock"
                text: sleepTimer.running ? Utils.durationFromMSecs(sleepTimer.remaining) : ""
                color: sleepTimer.running ? UbuntuColors.orange : "#b2b2b2"
                onClicked: sleepTimer.running = !sleepTimer.running
            }
        }

        Row {
            Label {
                id: positionLabel

                width: controls.width - durationLabel.width
                verticalAlignment: Text.AlignVCenter
                fontSize: "small"
                text: Utils.durationFromMSecs(player.position)
            }

            Label {
                id: durationLabel

                verticalAlignment: Text.AlignVCenter
                fontSize: "small"
                text: Utils.durationFromMSecs(player.duration)
                visible: player.duration > 0
            }
        }
        
        Label {
            id: statusLabel
            
            verticalAlignment: Text.AlignVCenter
            fontSize: "small"
            text: i18n.tr("Status") + ": " + (extractor.status == StreamExtractor.Loading ? i18n.tr("Loading")
                                                                                       : player.bufferProgress < 1
                                                                                       ? i18n.tr("Buffering")
                                                                                       : player.playbackState == Audio.PlayingState
                                                                                       ? i18n.tr("Playing")
                                                                                       : i18n.tr("Stopped"))
        }
    }

    states: State {
        name: "landscape"
        when: root.width > root.height
        AnchorChanges { target: flicker; anchors { right: parent.horizontalCenter; bottom: parent.bottom } }
        AnchorChanges { target: controls; anchors { left: parent.horizontalCenter; bottom: undefined; verticalCenter: parent.verticalCenter } }
    }
}
