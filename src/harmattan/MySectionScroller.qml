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
import "scripts/SectionScroller.js" as Sections
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI


Item {
    id: root

    property ListView listView

    onListViewChanged: {
        if (listView && listView.model) {
            internal.initDirtyObserver();
        } else if (listView) {
            listView.modelChanged.connect(function() {
                if (listView.model) {
                    internal.initDirtyObserver();
                }
            });
        }
    }

    Rectangle {
        id: container
        color: "transparent"
        width: 64
        height: listView.height
        x: listView.x + listView.width - width
        property bool dragging: false

        Image {
            anchors.fill: parent
            source: "image://theme/meegotouch-fast-scroll-rail" + (theme.inverted ? "-inverted" : "")
            fillMode: Image.Stretch
            opacity: (container.dragging) || (listView.movingVertically) ? 1 : 0

            Behavior on opacity { NumberAnimation { duration: 250 } }

            Image {
                y: listView.visibleArea.yPosition * listView.height
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
                source: "image://theme/meegotouch-fast-scroll-handle" + (theme.inverted ? "-inverted" : "")
                visible: (listView.movingVertically) && (!container.dragging)
            }
        }

        MouseArea {
            id: dragArea
            objectName: "dragArea"
            anchors.fill: parent
            drag.target: tooltip
            drag.axis: Drag.YAxis
            drag.minimumY: listView.y
            drag.maximumY: listView.y + listView.height - tooltip.height

            onPressed: {
                mouseDownTimer.restart()
            }

            onReleased: {
                container.dragging = false;
                mouseDownTimer.stop()
            }

            onPositionChanged: {
                internal.adjustContentPosition(dragArea.mouseY);
            }

            Timer {
                id: mouseDownTimer
                interval: 150

                onTriggered: {
                    container.dragging = true;
                    internal.adjustContentPosition(dragArea.mouseY);
                    tooltip.positionAtY(dragArea.mouseY);
                }
            }
        }
        Item {
            id: tooltip
            objectName: "popup"
            opacity: container.dragging ? 1 : 0
            anchors.right: parent.right
            width: listView.width
            height: childrenRect.height

            Behavior on opacity { NumberAnimation { duration: 250 } }

            function positionAtY(yCoord) {
                tooltip.y = Math.max(dragArea.drag.minimumY, Math.min(yCoord - tooltip.height/2, dragArea.drag.maximumY));
            }

            BorderImage {
                id: background
                width: listView.width
                height: currentSectionLabel.height + 40
                anchors.right: parent.right
                source: "image://theme/meegotouch-fast-scroll-magnifier" + (theme.inverted ? "-inverted" : "")
                border { left: 4; top: 4; right: 4; bottom: 4 }

                Label {
                    id: currentSectionLabel
                    objectName: "currentSectionLabel"
                    anchors {
                        left: parent.left
                        leftMargin: UI.PADDING_DOUBLE
                        right: parent.right
                        rightMargin: UI.PADDING_DOUBLE
                        verticalCenter: parent.verticalCenter
                    }
                    verticalAlignment: Text.AlignVCenter
                    height: 112
                    font.pixelSize: Math.min(width / (internal.currentSection.length / 2), height)
                    font.family: UI.FONT_FAMILY_LIGHT
                    color: theme.inverted ? UI.COLOR_FOREGROUND : UI.COLOR_INVERTED_FOREGROUND
                    text: internal.currentSection
                }
            }

            states: [
                State {
                    name: "visible"
                    when: container.dragging
                },

                State {
                    extend: "visible"
                    name: "atTop"
                    when: internal.curPos === "first"
                    PropertyChanges {
                        target: currentSectionLabel
                        text: internal.nextSection
                    }
                },

                State {
                    extend: "visible"
                    name: "atBottom"
                    when: internal.curPos === "last"
                    PropertyChanges {
                        target: currentSectionLabel
                        text: internal.prevSection
                    }
                }
            ]

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }
    }

    Timer {
        id: dirtyTimer
        interval: 100
        running: false
        onTriggered: {
            Sections.initSectionData(listView);
            internal.modelDirty = false;
        }
    }

    Connections {
        target: root.listView
        onCurrentSectionChanged: internal.curSect = container.dragging ? internal.curSect : ""
    }

    QtObject {
        id: internal

        property string prevSection: ""
        property string currentSection: listView.currentSection
        property string nextSection: ""
        property string curSect: ""
        property string curPos: "first"
        property int oldY: 0
        property bool modelDirty: false
        property bool down: true

        function initDirtyObserver() {
            Sections.initialize(listView);
            function dirtyObserver() {
                if (!modelDirty) {
                    modelDirty = true;
                    dirtyTimer.running = true;
                }
            }

            if (listView.model.countChanged)
                listView.model.countChanged.connect(dirtyObserver);

            if (listView.model.itemsChanged)
                listView.model.itemsChanged.connect(dirtyObserver);

            if (listView.model.itemsInserted)
                listView.model.itemsInserted.connect(dirtyObserver);

            if (listView.model.itemsMoved)
                listView.model.itemsMoved.connect(dirtyObserver);

            if (listView.model.itemsRemoved)
                listView.model.itemsRemoved.connect(dirtyObserver);
        }

        function adjustContentPosition(y) {
            if (y < 0 || y > dragArea.height) return;

            down = (y > oldY);
            var sect = Sections.getClosestSection((y / dragArea.height), down);
            oldY = y;
            if (curSect != sect) {
                curSect = sect;
                curPos = Sections.getSectionPositionString(curSect);
                var sec = Sections.getRelativeSections(curSect);
                prevSection = sec[0];
                currentSection = sec[1];
                nextSection = sec[2];
                var idx = Sections.getIndexFor(sect);
                listView.positionViewAtIndex(idx, ListView.Beginning);
            }
        }

    }
}
