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

ListItem {
    id: root
    
    Image {
        id: favouriteImage
        
        width: 48
        height: 48
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
        
        source: "image://icon/mediaplayer_internet_radio_favorite"
        smooth: true
        visible: is_favourite
    }
    
    Label {
        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingMedium
            right: is_favourite ? favouriteImage.left : parent.right
            rightMargin: platformStyle.paddingMedium
            top: parent.top
            topMargin: platformStyle.paddingMedium
        }
        elide: Text.ElideRight
        text: title
    }
    
    Label {
        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingMedium
            right: is_favourite ? favouriteImage.left : parent.right
            rightMargin: platformStyle.paddingMedium
            bottom: parent.bottom
            bottomMargin: platformStyle.paddingMedium
        }
        verticalAlignment: Text.AlignBottom
        elide: Text.ElideRight
        font.pointSize: platformStyle.fontSizeSmall
        color: platformStyle.secondaryTextColor
        text: genre + " | " + country + " | " + language
    }
}
