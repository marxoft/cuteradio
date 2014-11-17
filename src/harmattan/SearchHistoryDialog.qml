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
import org.marxoft.cuteradio 1.0

SelectionDialog {
    id: root

    titleText: qsTr("Previous searches")
    title: Item {
        id: header
        height: root.platformStyle.titleBarHeight

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Item {
            id: labelField

            anchors.fill:  parent

            Item {
                id: labelWrapper
                anchors.left: labelField.left
                anchors.right: progressIndicator.visible ? progressIndicator.left : closeButton.left
                anchors.bottom:  parent.bottom
                anchors.bottomMargin: root.platformStyle.titleBarLineMargin

                //anchors.verticalCenter: labelField.verticalCenter

                height: titleLabel.height

                Label {
                    id: titleLabel
                    x: root.platformStyle.titleBarIndent
                    width: parent.width
                    //anchors.baseline:  parent.bottom
                    font: root.platformStyle.titleBarFont
                    color: root.platformStyle.commonLabelColor
                    elide: root.platformStyle.titleElideMode
                    text: root.titleText
                }

            }

            BusyIndicator {
                id: progressIndicator

                anchors.bottom:  parent.bottom
                anchors.bottomMargin: root.platformStyle.titleBarLineMargin
                //anchors.verticalCenter: labelField.verticalCenter
                anchors.right: closeButton.left
                anchors.rightMargin: root.platformStyle.titleBarLineMargin
                running: visible
                visible: false
                platformStyle: BusyIndicatorStyle {
                    inverted: true
                }
            }

            Image {
                id: closeButton

                anchors.bottom:  parent.bottom
                anchors.bottomMargin: root.platformStyle.titleBarLineMargin-6
                //anchors.verticalCenter: labelField.verticalCenter
                anchors.right: labelField.right
                opacity: closeButtonArea.pressed ? 0.5 : 1.0
                source: "image://theme/icon-m-common-dialog-close"

                MouseArea {
                    id: closeButtonArea
                    anchors.fill: parent
                    onClicked:  {root.reject();}
                }

            }
        }

        Rectangle {
            id: headerLine

            anchors.left: parent.left
            anchors.right: parent.right

            anchors.bottom:  header.bottom

            height: 1

            color: "#4D4D4D"
        }

    }
    content: Item {

        id: selectionContent

        property int maxListViewHeight : visualParent
        ? visualParent.height * 0.87
                - root.platformStyle.titleBarHeight - root.platformStyle.contentSpacing - 50
        : root.parent
                ? root.parent.height * 0.87
                        - root.platformStyle.titleBarHeight - root.platformStyle.contentSpacing - 50
                : 350
        height: maxListViewHeight
        width: root.width
        y : root.platformStyle.contentSpacing

        ListView {
            id: selectionListView

            currentIndex : -1
            anchors.fill: parent
            model: NameCountModel {
                id: searchModel

                onStatusChanged: {
                    switch (status) {
                    case NameCountModel.Loading: {
                        progressIndicator.visible = true;
                        noResultsLabel.visible = false;
                        return;
                    }
                    case NameCountModel.Error:
                        infoBanner.showMessage(searchModel.errorString);
                        break;
                    default:
                        break;
                    }

                    progressIndicator.visible = false;
                    noResultsLabel.visible = (searchModel.count == 0);
                }
            }
            delegate: root.delegate
            focus: true
            clip: true
            pressDelay: __pressDelay

            ScrollDecorator {
                id: scrollDecorator
                flickableItem: selectionListView
                platformStyle.inverted: true
            }

            Label {
                id: noResultsLabel

                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                color: root.platformStyle.commonLabelColor
                font.bold: true
                font.pixelSize: 40
                text: qsTr("No searches found")
                visible: false
            }
        }

    }

    onAccepted: {
        var query = searchModel.data(selectedIndex, "name");
        appWindow.pageStack.push(Qt.resolvedUrl("SearchPage.qml"), { query: query });
    }

    onStatusChanged: {
        switch (status) {
        case DialogStatus.Opening:
            searchModel.getSearches();
            break;
        case DialogStatus.Closed:
            selectedIndex = -1;
            break;
        default:
            break;
        }
    }
}
