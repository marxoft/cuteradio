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
    title: qsTr("Search")
    
    Column {
        id: column
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMedium
            top: parent.top
            bottom: parent.bottom
        }
        spacing: platformStyle.paddingMedium
        
        TextField {
            id: searchField
            
            width: parent.left
            placeholderText: qsTr("Search query")
            validator: RegExpValidator {
                regExp: /^.+/
            }
            onAccepted: root.accept()
        }
        
        ListView {
            id: view
            
            width: parent.width
            height: parent.height - searchField.height - parent.spacing
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            model: NameCountModel {
                id: searchModel
                
                onStatusChanged: {
                    switch (status) {
                    case NameCountModel.Loading: {
                        root.showProgressIndicator = true;
                        noResultsLabel.visible = false;
                        return;
                    }
                    case NameCountModel.Error:
                        informationBox.information(searchModel.errorString);
                        break;
                    default:
                        break;
                    }
                    
                    root.showProgressIndicator = false;
                    noResultsLabel.visible = (searchModel.count == 0);
                }
            }
            delegate: SearchDelegate {
                onClicked: searchField.text = name
            }
            
            Label {
                id: noResultsLabel
                
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: platformStyle.fontSizeLarge
                color: platformStyle.disabledTextColor
                text: qsTr("No searches found")
                visible: false
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
        enabled: searchField.acceptableInput
        onClicked: root.accept()
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
                target: column
                anchors {
                    right: parent.right
                    bottom: button.top
                }
            }
        
            PropertyChanges {
                target: column
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
    
    onAccepted: windowStack.push(Qt.resolvedUrl("SearchWindow.qml"), { query: searchField.text })
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            searchField.clear();
            searchField.focus = true;
            searchModel.getSearches();
        }
    }
}
