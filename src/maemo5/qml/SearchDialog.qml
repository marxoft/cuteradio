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

Dialog {
    id: root
    
    height: searchField.height + platformStyle.paddingMedium
    title: qsTr("Search")
    
    TextField {
        id: searchField
        
        anchors {
            left: parent.left
            right: acceptButton.left
            rightMargin: platformStyle.paddingMedium
            bottom: parent.bottom
        }
        placeholderText: qsTr("Search query")
        onAccepted: root.accept()
    }
    
    Button {
        id: acceptButton
        
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        style: DialogButtonStyle {}
        text: qsTr("Done")
        enabled: searchField.text != ""
        onClicked: root.accept()
    }
    
    StateGroup {
        states: State {
            name: "Portrait"
            when: screen.currentOrientation == Qt.WA_Maemo5PortraitOrientation
        
            PropertyChanges {
                target: root
                height: searchField.height + acceptButton.height + platformStyle.paddingMedium * 2
            }
        
            AnchorChanges {
                target: searchField
                anchors {
                    right: parent.right
                    bottom: acceptButton.top
                }
            }
        
            PropertyChanges {
                target: searchField
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
        windowStack.push(Qt.resolvedUrl("StationsWindow.qml"),
                        {title: qsTr("Search") + " ('" + searchField.text + "')", filters: {search: searchField.text}});
        windowStack.currentWindow.reload();
    }
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            searchField.clear();
            searchField.forceActiveFocus();
        }
    }
}
