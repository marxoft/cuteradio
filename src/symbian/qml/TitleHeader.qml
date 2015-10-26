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

import QtQuick 1.1
import com.nokia.symbian 1.1

ListHeading {
    id: root

    z: 1000
    height: 40
    anchors {
        left: parent.left
        right: parent.right
        top: parent.top
    }
    parent: appWindow.pageStack
    opacity: (appWindow.pageStack.currentPage === null) || (!appWindow.pageStack.currentPage.title) ? 0 : 1

    Behavior on opacity { NumberAnimation { duration: 200 } }

    Rectangle {
        height: 1
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: ACTIVE_COLOR
        opacity: 0.5
    }

    Label {
        id: title

        anchors {
            left: parent.left
            leftMargin: platformStyle.paddingLarge
            verticalCenter: parent.verticalCenter
            right: progressIndicator.visible ? progressIndicator.left : parent.right
            rightMargin: platformStyle.paddingLarge
        }
        font.bold: true
        elide: Text.ElideRight
        text: appWindow.pageStack.currentPage === null ? "" : appWindow.pageStack.currentPage.title
    }

    BusyIndicator {
        id: progressIndicator

        width: 28
        height: 28
        anchors {
            right: parent.right
            rightMargin: platformStyle.paddingLarge
            verticalCenter: parent.verticalCenter
        }
        running: visible
        visible: (appWindow.pageStack.currentPage) && (appWindow.pageStack.currentPage.showProgressIndicator)
    }

    MouseArea {
        anchors.fill: parent
    }
}
