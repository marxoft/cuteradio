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
import CuteRadioApp 1.0

Dialog {
    id: root
    
    height: Math.min(360, column.height + platformStyle.paddingMedium)
    title: qsTr("Settings")
    
    Flickable {
        id: flicker
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMedium
            top: parent.top
            bottom: parent.bottom
        }
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        contentHeight: column.height
    
        Column {
            id: column
            
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: platformStyle.paddingMedium
            
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: platformStyle.secondaryTextColor
                text: qsTr("General")
            }
            
            Label {
                width: parent.width
                text: qsTr("Sleep timer duration (mins)")
            }
            
            SpinBox {
                id: sleepField
                
                width: parent.width
                minimum: 1
                maximum: 999
            }
            
            CheckBox {
                id: playedCheckBox
                
                width: parent.width
                text: qsTr("Send played stations data")
            }
            
            ValueButton {
                id: orientationButton
                
                width: parent.width
                text: qsTr("Screen orientation")
                pickSelector: ListPickSelector {
                    id: orientationSelector
                    
                    textRole: "name"
                    model: ScreenOrientationModel {
                        id: orientationModel
                    }
                }
            }
            
            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: platformStyle.secondaryTextColor
                text: qsTr("Keyboard shortcuts")
            }
            
            Label {
                width: parent.width
                text: qsTr("Toggle playback")
            }
            
            TextField {
                id: togglePlaybackShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Playlist next")
            }
            
            TextField {
                id: playbackNextShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Playlist previous")
            }
            
            TextField {
                id: playbackPreviousShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Show now playing")
            }
            
            TextField {
                id: nowPlayingShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Toggle sleep timer")
            }
            
            TextField {
                id: sleepTimerShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Play URL")
            }
            
            TextField {
                id: playUrlShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Search")
            }
            
            TextField {
                id: searchShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Settings")
            }
            
            TextField {
                id: settingsShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Add station")
            }
            
            TextField {
                id: addStationShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("View station details")
            }
            
            TextField {
                id: stationDetailsShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Edit station details")
            }
            
            TextField {
                id: editStationShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Toggle station favourite")
            }
            
            TextField {
                id: stationFavouriteShortcutField
                
                width: parent.width
            }
            
            Label {
                width: parent.width
                text: qsTr("Reload content")
            }
            
            TextField {
                id: reloadShortcutField
                
                width: parent.width
            }
        }
    }
    
    Button {
        id: acceptButton
        
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        style: DialogButtonStyle {}
        text: qsTr("Save")
        onClicked: root.accept()
    }
        
    StateGroup {
        states: State {
            name: "Portrait"
            when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation
        
            PropertyChanges {
                target: root
                height: column.height + acceptButton.height + platformStyle.paddingMedium * 2
            }
        
            AnchorChanges {
                target: flicker
                anchors {
                    right: parent.right
                    bottom: acceptButton.top
                }
            }
        
            PropertyChanges {
                target: flicker
                anchors {
                    rightMargin: 0
                    bottomMargin: platformStyle.paddingMedium
                }
            }
        
            PropertyChanges {
                target: acceptButton
                width: parent.width
            }
        }
    }
    
    onAccepted: {
        Settings.sleepTimerDuration = sleepField.value;
        Settings.sendPlayedStationsData = playedCheckBox.checked;
        Settings.screenOrientation = orientationModel.data(orientationSelector.currentIndex, "value");
        screen.orientationLock = Settings.screenOrientation;
        Settings.togglePlaybackShortcut = togglePlaybackShortcutField.text;
        Settings.playbackNextShortcut = playbackNextShortcutField.text;
        Settings.playbackPreviousShortcut = playbackPreviousShortcutField.text;
        Settings.nowPlayingShortcut = nowPlayingShortcutField.text;
        Settings.sleepTimerShortcut = sleepTimerShortcutField.text;
        Settings.playUrlShortcut = playUrlShortcutField.text;
        Settings.searchShortcut = searchShortcutField.text;
        Settings.settingsShortcut = settingsShortcutField.text;
        Settings.addStationShortcut = addStationShortcutField.text;
        Settings.stationDetailsShortcut = stationDetailsShortcutField.text;
        Settings.editStationShortcut = editStationShortcutField.text;
        Settings.stationFavouriteShortcut = stationFavouriteShortcutField.text;
        Settings.reloadShortcut = reloadShortcutField.text;
    }
    
    Component.onCompleted: {
        sleepField.value = Settings.sleepTimerDuration;
        playedCheckBox.checked = Settings.sendPlayedStationsData;
        orientationSelector.currentIndex = orientationModel.match("value", Settings.screenOrientation);
        togglePlaybackShortcutField.text = Settings.togglePlaybackShortcut;
        playbackNextShortcutField.text = Settings.playbackNextShortcut;
        playbackPreviousShortcutField.text = Settings.playbackPreviousShortcut;
        nowPlayingShortcutField.text = Settings.nowPlayingShortcut;
        sleepTimerShortcutField.text = Settings.sleepTimerShortcut;
        playUrlShortcutField.text = Settings.playUrlShortcut;
        searchShortcutField.text = Settings.searchShortcut;
        settingsShortcutField.text = Settings.settingsShortcut;
        addStationShortcutField.text = Settings.addStationShortcut;
        stationDetailsShortcutField.text = Settings.stationDetailsShortcut;
        editStationShortcutField.text = Settings.editStationShortcut;
        stationFavouriteShortcutField.text = Settings.stationFavouriteShortcut;
        reloadShortcutField.text = Settings.reloadShortcut;
    }
}
