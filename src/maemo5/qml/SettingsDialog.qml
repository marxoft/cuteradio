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
    
    height: column.height + platformStyle.paddingMedium
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
                pickSelector: orientationSelector
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
        text: qsTr("Done")
        onClicked: root.accept()
    }
    
    ListPickSelector {
        id: orientationSelector
        
        textRole: "name"
        model: ScreenOrientationModel {
            id: orientationModel
        }
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
    }
    
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            sleepField.value = Settings.sleepTimerDuration;
            playedCheckBox.checked = Settings.sendPlayedStationsData;
            orientationSelector.currentIndex = orientationModel.match("value", Settings.screenOrientation);
        }
    }
}
