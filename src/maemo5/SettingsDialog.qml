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
import org.marxoft.cuteradio 1.0

Dialog {
    id: root
    
    height: 360
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
            
            TextField {
                id: sleepField
                
                width: parent.width
                validator: IntValidator {
                    bottom: 1
                    top: 999
                }
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
            
            ValueButton {
                id: languageButton
                
                width: parent.width
                text: qsTr("Language")
                pickSelector: languageSelector
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
    
    ListPickSelector {
        id: languageSelector
        
        textRole: "name"
        model: LanguageModel {
            id: languageModel
        }
    }
    
    StateGroup {
        states: State {
            name: "Portrait"
            when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation
        
            PropertyChanges {
                target: root
                height: 680
            }
        
            AnchorChanges {
                target: flicker
                anchors {
                    right: parent.right
                    bottom: button.top
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
        Settings.sleepTimerDuration = parseInt(sleepField.text);
        Settings.sendPlayedStationsData = playedCheckBox.checked;
        Settings.screenOrientation = orientationModel.value(orientationSelector.currentIndex);
        Settings.language = languageModel.value(languageSelector.currentIndex);
        screen.orientationLock = Settings.screenOrientation;
    }
    
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            sleepField.text = Settings.sleepTimerDuration;
            playedCheckBox.checked = Settings.sendPlayedStationsData;
            orientationSelector.currentIndex = orientationModel.match("value", Settings.screenOrientation);
            languageSelector.currentIndex = languageModel.match("value", Settings.language);
        }
    }
}
