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

Window {
    id: root
    
    title: player.currentStation.title
    objectName: "NowPlayingWindow"
    menuBar: MenuBar {
        SleepTimerMenuItem {}
    }
    
    Image {
        id: image
        
        width: 295
        height: 295
        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingLarge * 2
            top: parent.top
            topMargin: platformStyle.paddingLarge * 2
        }
        source: "/usr/share/icons/hicolor/295x295/hildon/mediaplayer_default_stream.png"
    }
    
    Column {
        id: infoColumn
        
        anchors {
            left: image.right
            right: parent.right
            verticalCenter: image.verticalCenter
            margins: platformStyle.paddingLarge * 2
        }
        spacing: platformStyle.paddingLarge
        
        Label {
            width: parent.width
            elide: Text.ElideRight
            text: player.metaData.organization ? player.metaData.organization : player.currentStation.title
        }
        
        Label {
            width: parent.width
            elide: Text.ElideRight
            color: platformStyle.secondaryTextColor
            text: (!player.metaData.title) ||
            (player.metaData.title == player.source.substring(player.source.lastIndexOf("/") + 1))
            ? qsTr("(unknown artist) / (unknown song)") : player.metaData.title
        }
        
        Row {
            width: parent.width
            spacing: platformStyle.paddingLarge
            
            Label {
                width: 50
                height: bufferBar.height
                verticalAlignment: Text.AlignVCenter
                font.pointSize: platformStyle.fontSizeSmall
                text: Utils.formatSecs(positionSlider.enabled ? positionSlider.value : player.position)
            }
            
            ProgressBar {
                id: bufferBar
                
                width: parent.width - 100 - parent.spacing * 2
                value: Math.round(player.bufferProgress * 100)
                textVisible: true
                text: qsTr("Buffering") + " " + value + "%"
                visible: (player.playing) && (player.bufferProgress < 1.0)
            }
            
            Item {
                width: parent.width - 100 - parent.spacing * 2
                height: bufferBar.height
                
                Slider {
                    id: positionSlider
                
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    maximum: player.duration
                    enabled: (player.seekable) && (player.duration > 0)
                    visible: !bufferBar.visible
                    onPressedChanged: if (!pressed) player.position = value;
                
                    Connections {
                        target: positionSlider.enabled ? player : null
                        onPositionChanged: if (!positionSlider.pressed) positionSlider.value = player.position;
                    }
                
                    Component.onCompleted: value = player.position
                }
            }
            
            Label {
                width: 50
                height: bufferBar.height
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pointSize: platformStyle.fontSizeSmall
                text: player.duration > 0 ? Utils.formatSecs(player.duration) : "--:--"
            }
        }
        
        Label {
            width: parent.width
            elide: Text.ElideRight
            color: platformStyle.secondaryTextColor
            text: player.metaData.genre ? player.metaData.genre : qsTr("(unknown genre)")
        }
    }
    
    ToolButtonStyle {
        id: transparentToolButtonStyle
        
        background: ""
        backgroundChecked: ""
        backgroundDisabled: ""
        backgroundPressed: ""
        iconWidth: 64
        iconHeight: 64
    }
    
    ToolButton {
        id: volumeButton
        
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingLarge
            bottom: parent.bottom
        }
        checkable: true
        iconName: "mediaplayer_volume"
        style: transparentToolButtonStyle
    }
    
    Loader {
        id: toolsLoader
        
        height: 70
        anchors {
            left: image.left
            right: volumeButton.left
            bottom: parent.bottom
        }
        sourceComponent: volumeButton.checked ? volumeSlider : playbackControls
    }
    
    Component {
        id: playbackControls
        
        Row {
            spacing: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation ? 0 : 42
            
            ToolButton {
                action: playbackPreviousAction
                iconSource: "/etc/hildon/theme/mediaplayer/Back" + (pressed ? "Pressed" : "") + ".png"
                style: transparentToolButtonStyle
            }
            
            ToolButton {
                action: togglePlaybackAction
                iconSource: "/etc/hildon/theme/mediaplayer/" + (player.playing ? "Stop" : "Play") + ".png"
                style: transparentToolButtonStyle
            }
            
            ToolButton {
                action: playbackNextAction
                iconSource: "/etc/hildon/theme/mediaplayer/Forward" + (pressed ? "Pressed" : "") + ".png"
                style: transparentToolButtonStyle
            }
        }
    }
    
    Component {
        id: volumeSlider
        
        Item {
            Slider {
                id: vSlider
                
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                onPressedChanged: if (!pressed) player.volume = value;
            
                Connections {
                    target: player
                    onVolumeChanged: if (!vSlider.pressed) vSlider.value = player.volume;
                }
            
                Timer {
                    interval: 3000
                    running: !vSlider.pressed
                    onTriggered: volumeButton.checked = false
                }
            
                Component.onCompleted: value = player.volume
            }
        }
    }
    
    Binding {
        target: player
        property: "tickInterval"
        value: 1000
        when: !screen.covered
    }
    
    StateGroup {
        states: State {
            name: "Portrait"
            when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation
        
            PropertyChanges {
                target: image
                anchors.leftMargin: Math.floor((root.width - width) / 2)
            }
        
            AnchorChanges {
                target: infoColumn
                anchors {
                    verticalCenter: undefined
                    left: parent.left
                    top: image.bottom
                    bottom: toolsLoader.top
                }
            }
            
            AnchorChanges {
                target: toolsLoader
                anchors.left: parent.left
            }
        
            PropertyChanges {
                target: toolsLoader
                anchors.leftMargin: platformStyle.paddingLarge
            }
        }
    }
}
