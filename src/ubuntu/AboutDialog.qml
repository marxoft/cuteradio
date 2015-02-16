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

Dialog {
    id: root
    
    title: "cuteradio " + VERSION_NUMBER
    contents: Column {
        width: parent.width
        spacing: units.gu(1)
        
        Image {
            width: units.gu(6)
            height: width
            x: (parent.width - width) / 2
            sourceSize.width: width
            sourceSize.height: height
            source: "images/cuteradio.png"
        }
        
        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text: i18n.tr("A user-friendly internet radio player and client for the cuteRadio internet radio service.")
        }
        
        Label {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Copyright Stuart Howarth 2015"
        }
    }
    
    Button {
        text: i18n.tr("Website")
        iconName: "stock_website"
        color: UbuntuColors.orange
        onClicked: Qt.openUrlExternally("http://marxoft.co.uk/projects/cuteradio/")
    }

    Button {
        text: i18n.tr("Close")
        iconName: "close"
        onClicked: PopupUtils.close(root);
    }
}
