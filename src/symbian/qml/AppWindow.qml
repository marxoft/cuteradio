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

Window {
    id: window

    property bool showStatusBar: true
    property bool showToolBar: true
    property variant initialPage
    property alias pageStack: stack
    property bool cornersVisible: true

    objectName: "pageStackWindow"

    MyStatusBar {
        id: statusBar

        anchors {
            top: parent.top
            topMargin: window.showStatusBar ? 0 : -height
        }
        width: parent.width
        title: stack.currentPage ? stack.currentPage.title : ""
    }

    Item {
        id: contentItem

        objectName: "appWindowContent"
        width: parent.width
        anchors.top: window.showStatusBar ? statusBar.bottom : parent.top
        anchors.bottom: parent.bottom

        ToolBar {
            id: toolBar

            anchors.bottom: parent.bottom
            states: State {
                name: "hide"
                when: (!window.showToolBar) || (inputContext.softwareInputPanelVisible) || (inputContext.customSoftwareInputPanelVisible)
                PropertyChanges { target: toolBar; height: 0; opacity: 0.0 }
            }
        }

        PageStack {
            id: stack

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: toolBar.top
            }
            clip: true
            toolBar: toolBar
        }
    }

    // event preventer when page transition is active
    MouseArea {
        anchors.fill: parent
        enabled: pageStack.busy
    }

    Component.onCompleted: if (initialPage) pageStack.push(initialPage);
}
