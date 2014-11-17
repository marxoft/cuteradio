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

Dialog {
    id: root
    
    windowTitle: qsTr("About")
    height: window.inPortrait ? 240 : 200
    content: Column {
        anchors.fill: parent

        Row {

            Image {
                width: 64
                height: 64
                source: "/usr/share/icons/hicolor/64x64/apps/cuteradio.png"
            }

            Label {
                font.bold: true
                font.pixelSize: platformStyle.fontSizeLarge
                text: "cuteRadio " + VERSION_NUMBER
            }
        }

        Label {
            wordWrap: true
            text: qsTr("A user-friendly internet radio player and client for the cuteRadio internet radio service.")
                  + "<br><br>&copy; Stuart Howarth 2014"
        }
    }
}
