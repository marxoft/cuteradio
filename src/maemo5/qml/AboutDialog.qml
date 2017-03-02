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
    
    title: qsTr("About")
    height: column.height + platformStyle.paddingMedium
    
    Column {
        id: column
        
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        spacing: platformStyle.paddingMedium

        Row {
            width: parent.width
            spacing: platformStyle.paddingMedium
            
            Image {
                width: 64
                height: 64
                source: "image://icon/cuteradio"
            }

            Label {
                width: parent.width
                height: 64
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pointSize: platformStyle.fontSizeLarge
                text: "cuteRadio " + VERSION_NUMBER
            }
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("A user-friendly internet radio player and client for the cuteRadio internet radio service.")
                  + "<br><br>&copy; Stuart Howarth 2015-2017"
        }
    }
}
