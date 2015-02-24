/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
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

import QtQuick 2.2
import Ubuntu.Components 1.1

ExpandableDelegate {
    id: root
            
    Column {
        id: column
        
        anchors {
            left: parent.left
            right: is_favourite ? icon.left : parent.right
            rightMargin: is_favourite ? units.gu(1) : 0
            verticalCenter: parent.verticalCenter
        }
        
        Label {            
            width: parent.width
            elide: Text.ElideRight
            fontSize: "medium"
            color: root.selected ? UbuntuColors.orange : Theme.palette.selected.backgroundText
            text: title
        }

        Label {            
            width: parent.width
            elide: Text.ElideRight
            fontSize: "small"
            color: root.selected ? UbuntuColors.orange : Theme.palette.normal.backgroundText
            text: genre + " | " + country + " | " + language
        }
    }
    
    Icon {
        id: icon
        
        width: Math.floor(parent.height / 2)
        height: width
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        name: "starred"
        visible: is_favourite
    }
}
