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
import org.marxoft.cuteradio 1.0

Dialog {
    id: root
    
    height: window.inPortrait ? 680 : 360
    windowTitle: qsTr("Settings")
    content: Flickable {
        id: flicker
        
        anchors.fill: parent
    
        Column {
            id: column
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Media")
            }
            
            Label {
                text: qsTr("Sleep timer duration")
            }
            
            SpinBox {
                id: sleepSpinBox
                
                minimum: 1
                maximum: 999
                suffix: " " + qsTr("mins")
            }
            
            CheckBox {
                id: playedCheckBox
                
                text: qsTr("Send played stations data")
            }
            
            Label {
                color: platformStyle.secondaryTextColor
                text: qsTr("Other")
            }
            
            ValueButton {
                id: orientationButton
                
                text: qsTr("Screen orientation")
                selector: ListSelector {
                    id: orientationSelector
                    
                    model: ScreenOrientationModel {
                        id: orientationModel
                    }
                }
            }
            
            ValueButton {
                id: languageButton
                
                text: qsTr("Language")
                selector: ListSelector {
                    id: languageSelector
                    
                    model: LanguageModel {
                        id: languageModel
                    }
                }
            }
        }
    }
    
    buttons: Button {
        focusPolicy: Qt.NoFocus
        text: qsTr("Done")
        onClicked: root.accept()
    }
    
    onAccepted: {
        Settings.sleepTimerDuration = sleepSpinBox.value;
        Settings.sendPlayedStationsData = playedCheckBox.checked;
        Settings.screenOrientation = orientationModel.value(orientationSelector.currentIndex);
        Settings.language = languageModel.value(languageSelector.currentIndex);
        screen.orientationLock = Settings.screenOrientation;
    }
    
    onVisibleChanged: {
        if (visible) {
            sleepSpinBox.value = Settings.sleepTimerDuration;
            playedCheckBox.checked = Settings.sendPlayedStationsData;
            orientationSelector.currentIndex = orientationModel.match("value", Settings.screenOrientation);
            languageSelector.currentIndex = languageModel.match("value", Settings.language);
        }
    }
}
