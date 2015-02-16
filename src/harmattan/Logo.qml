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
import com.nokia.meego 1.0

Item {
    id: root

    property alias source: thumb.source
    property string text

    signal clicked

    width: 64
    height: 64
    smooth: true
    opacity: mouseArea.pressed ? 0.5 : 1

    Image {
        id: thumb

        anchors.fill: parent
        smooth: true
        asynchronous: true
    }

    Label {
        property string _text: thumb.status == Image.Ready ? "" : root.text.toUpperCase() + " <font color='" + Qt.lighter(Settings.activeColor) + "'>" + root.text.toUpperCase() + "</font>"

        visible: thumb.status != Image.Ready
        anchors.fill: parent
        lineHeight: Math.floor(height / 4)
        lineHeightMode: Text.FixedHeight
        horizontalAlignment: Text.AlignJustify
        wrapMode: Text.WrapAnywhere
        font.bold: true
        font.pixelSize: Math.floor(lineHeight / 1.3)
        clip: true
        color: Settings.activeColor
        text: thumb.status == Image.Ready ? "" : _text + " " + _text + " " + _text + " " + _text + " " + _text + " " + _text
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        enabled: root.enabled
        onClicked: root.clicked()
    }
}
