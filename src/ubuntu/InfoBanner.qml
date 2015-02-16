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
import Ubuntu.Components.Popups 1.0

Popover {
	id: root

    property alias text: label.text
    
    Label {
        id: label
        
        height: units.gu(12)
        anchors {
            left: parent.left
            leftMargin: units.gu(1)
            right: parent.right
            rightMargin: units.gu(1)
            top: parent.top
        }
        elide: Text.ElideRight
        maximumLineCount: 4
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
	
	Timer {
		id: timer
		
		interval: 3000
		repeat: false
		running: root.visible
		onTriggered: PopupUtils.close(root)
	}
}
