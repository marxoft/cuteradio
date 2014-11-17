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
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

Dialog {
    id: root

    content: Item {
        height: column.height
        anchors {
            left: parent.left
            right: parent.right
            margins: UI.PADDING_DOUBLE
        }

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: UI.PADDING_DOUBLE

            Image {
                id: icon

                x: parent.width / 2 - width / 2
                source: "images/cuteradio.png"
            }

            Label {
                id: titleLabel

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pixelSize: UI.FONT_XLARGE
                color: "white"
                text: "cuteRadio " + VERSION_NUMBER
            }

            Label {
                id: aboutLabel

                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                text: qsTr("A user-friendly internet radio player and client for the cuteRadio internet radio service.")
                  + "<br><br>&copy; Stuart Howarth 2014"
            }

            LinkLabel {
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("View changelog")
                onClicked: {
                    root.accept();
                    appWindow.pageStack.push(Qt.resolvedUrl("ChangelogPage.qml"));
                }
            }

            LinkLabel {
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                text: "<font color ='" + UI.COLOR_INVERTED_FOREGROUND + "'>" + qsTr("Contact") + ": </font><u>showarth@marxoft.co.uk</u>"
                link: "mailto:showarth@marxoft.co.uk?subject=cuteRadio " + VERSION_NUMBER + " for N9"
                onClicked: root.accept()
            }
        }
    }
}
