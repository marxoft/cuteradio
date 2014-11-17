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

ListItem {
    id: root
    
    width: view.width - platformStyle.paddingMedium
    height: 80
    
    ListItemImage {
        anchors.fill: parent
        source: "image://theme/TouchListBackground" + (isCurrentItem ? "Pressed" : "Normal")
        smooth: true
    }
    
    ListItemLabel {
        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingMedium
            right: image.left
            rightMargin: platformStyle.paddingMedium
            top: parent.top
            bottom: parent.bottom
        }
        
        alignment: Qt.AlignVCenter
        font.bold: true
        text: modelData.name
    }
    
    ListItemImage {
        id: image
        
        width: 48
        height: 48
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
        
        source: "/usr/share/icons/hicolor/48x48/hildon/general_forward.png"
        smooth: true
    }
}
