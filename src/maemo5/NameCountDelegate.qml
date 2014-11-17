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
            right: parent.right
            rightMargin: platformStyle.paddingMedium
            top: parent.top
            topMargin: platformStyle.paddingMedium
            bottom: parent.verticalCenter
        }
        
        text: modelData.name
    }
    
    ListItemLabel {
        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingMedium
            right: parent.right
            rightMargin: platformStyle.paddingMedium
            top: parent.verticalCenter
            bottom: parent.bottom
            bottomMargin: platformStyle.paddingMedium
        }

        alignment: Qt.AlignLeft | Qt.AlignBottom
        font.pixelSize: platformStyle.fontSizeSmall
        color: platformStyle.secondaryTextColor
        text: modelData.item_count + " " + qsTr("stations")
    }
}
