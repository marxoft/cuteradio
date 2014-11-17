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

Rectangle {
    id: root
    
    property alias text: edit.text
    
    border.width: 1
    border.color: edit.focus ? "green" : "black"
    
    Flickable {
        anchors {
            fill: parent
            margins: 2
        }
        clip: true
        contentHeight: edit.height
    
        TextEdit {
            id: edit
            
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            readOnly: true
        }
    }
}
