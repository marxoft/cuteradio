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
    
    Loader {
        id: favouriteLoader
        
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingMedium
            verticalCenter: parent.verticalCenter
        }
        sourceComponent: favourite ? favouriteImage : undefined
    }
        
    Label {
        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingMedium
            right: favouriteLoader.left
            rightMargin: favouriteLoader.item ? platformStyle.paddingMedium : 0
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
            right: favouriteLoader.left
            rightMargin: favouriteLoader.item ? platformStyle.paddingMedium : 0
            bottom: parent.bottom
            bottomMargin: platformStyle.paddingMedium
        }
        verticalAlignment: Text.AlignBottom
        elide: Text.ElideRight
        font.pointSize: platformStyle.fontSizeSmall
        color: platformStyle.secondaryTextColor
        text: genre + " | " + country + " | " + language
    }
    
    Component {
        id: favouriteImage
        
        Image {        
            width: 48
            height: 48
            source: "image://icon/mediaplayer_internet_radio_favorite"
            smooth: true
        }
    }
}
