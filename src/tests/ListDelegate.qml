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

Item {
    id: root
    
    signal clicked
    signal pressAndHold
    
    property alias text: titleLabel.text
    property alias subText: subTitleLabel.text
    property alias pressed: mouseArea.pressed
    
    width: parent ? parent.width : 800
    height: 40
    
    Label {
        id: titleLabel
        
        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            top: parent.top
            bottom: parent.verticalCenter
        }
        verticalAlignment: Text.AlignVCenter
    }
    
    Label {
        id: subTitleLabel
        
        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            top: parent.verticalCenter
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        color: "grey"
    }
    
    Rectangle {
        height: mouseArea.pressed ? parent.height : 1
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: "grey"
        opacity: 0.5
    }
    
    MouseArea {
        id: mouseArea
        
        anchors.fill: parent
        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold()
    }
}
