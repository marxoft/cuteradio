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

Page {
    id: root
    
    windowTitle: player.currentStation.title
    tools: SleepTimerAction {}
    
    Image {
        id: image
        
        width: 295
        height: 295
        anchors {
            top: parent.top
            topMargin: platformStyle.paddingLarge * 2
            left: parent.left
            leftMargin: window.inPortrait ? Math.floor((root.width - width) / 2)
                                          : platformStyle.paddingLarge * 2
        }
        source: (!player.currentStation.logo) || (status == Image.Error)
                 ? "/usr/share/icons/hicolor/295x295/hildon/mediaplayer_default_stream.png"
                 : player.currentStation.logo
                
        smooth: true
    }
    
    Column {
        id: infoColumn
        
        anchors {
            top: window.inPortrait ? image.bottom : image.top
            bottom: toolsLoader.item.top
            left: window.inPortrait ? parent.left : image.right
            right: parent.right
            margins: platformStyle.paddingLarge * 2
        }
        
        Label {
            text: player.metaData.organization ? player.metaData.organization : player.currentStation.title
        }
        
        Label {
            color: platformStyle.secondaryTextColor
            text: (!player.metaData.title) || (player.metaData.title == player.source.substring(player.source.lastIndexOf("/") + 1))
                   ? qsTr("(unknown artist) / (unknown song)") : player.metaData.title
        }
        
        Row {
            
            Label {
                height: positionSlider.height
                alignment: Qt.AlignLeft | Qt.AlignVCenter
                font.pixelSize: platformStyle.fontSizeSmall
                text: Utils.durationFromSecs(positionSlider.enabled ? positionSlider.value : player.position)
            }
            
            ProgressBar {
                id: bufferBar
                
                height: 70
                maximum: 100
                value: Math.round(player.bufferProgress * 100)
                textVisible: true
                format: qsTr("Buffering") + " %p%"
                visible: (player.playing) && (player.bufferProgress < 1.0)
            }
            
            Slider {
                id: positionSlider
                
                height: 70
                maximum: player.duration
                enabled: (player.seekable) && (player.duration > 0)
                visible: !bufferBar.visible
                onSliderReleased: player.position = value
                
                Connections {
                    target: positionSlider.enabled ? player : null
                    onPositionChanged: if (!positionSlider.sliderPressed) positionSlider.value = player.position;
                }
                
                Component.onCompleted: value = player.position
            }
            
            Label {
                height: positionSlider.height
                alignment: Qt.AlignRight | Qt.AlignVCenter
                font.pixelSize: platformStyle.fontSizeSmall
                text: player.duration > 0 ? Utils.durationFromSecs(player.duration) : "--:--"
            }
        }
        
        Label {
            color: platformStyle.secondaryTextColor
            text: player.metaData.genre ? player.metaData.genre : qsTr("(unknown genre)")
        }
    }
    
    ToolButton {
        id: volumeButton
        
        width: 70
        height: 70
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingLarge
            bottom: parent.bottom
        }
        styleSheet: "background: transparent"
        checkable: true
        iconSize: "64x64"
        icon: "/usr/share/icons/hicolor/64x64/hildon/mediaplayer_volume.png"
    }
    
    Loader {
        id: toolsLoader
        
        sourceComponent: volumeButton.checked ? volumeSlider : playbackControls
    }
    
    Component {
        id: playbackControls
        
        Row {
            anchors {
                left: parent.left
                leftMargin: platformStyle.paddingLarge * (window.inPortrait ? 1 : 2)
                right: volumeButton.left
                bottom: parent.bottom
            }
            height: 70
            spacing: window.inPortrait ? 0 : 35
            
            ToolButton {
                styleSheet: "background: transparent"
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/Back" + (pressed ? "Pressed" : "") + ".png"
                shortcut: "Left"
                onClicked: playlist.previous()
            }
            
            ToolButton {
                styleSheet: "background: transparent"
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/" + (player.playing ? "Stop" : "Play") + ".png"
                shortcut: "Space"
                onClicked: player.playing ? player.stop() : player.restart()
            }
            
            ToolButton {
                styleSheet: "background: transparent"
                iconSize: "64x64"
                icon: "/etc/hildon/theme/mediaplayer/Forward" + (pressed ? "Pressed" : "") + ".png"
                shortcut: "Right"
                onClicked: playlist.next()
            }
        }
    }
    
    Component {
        id: volumeSlider
        
        Slider {
            id: vSlider
            
            height: 70
            anchors {
                left: parent.left
                leftMargin: platformStyle.paddingLarge * (window.inPortrait ? 1 : 2)
                right: volumeButton.left
                bottom: parent.bottom
            }
            maximum: 100
            onSliderReleased: player.volume = value
            
            Connections {
                target: player
                onVolumeChanged: if (!vSlider.sliderPressed) vSlider.value = player.volume;
            }
            
            Timer {
                interval: 3000
                running: !vSlider.sliderPressed
                onTriggered: volumeButton.checked = false
            }
            
            Component.onCompleted: value = player.volume
        }
    }
    
    Binding {
        target: player
        property: "tickInterval"
        value: 1000
        when: !screen.covered
    }
}
    
