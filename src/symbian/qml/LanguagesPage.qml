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
import CuteRadio 1.0 as CuteRadio

MyPage {
    id: root
    
    function reload() {
        languageModel.reload();
    }

    title: qsTr("Stations by language")
    tools: ToolBarLayout {

        BackToolButton {}

        NowPlayingButton {}

        MyToolButton {
            anchors.right: parent.right
            iconSource: "toolbar-refresh"
            toolTipText: qsTr("Reload")
            onClicked: languageModel.reload()
        }
    }

    MyListView {
        id: view

        anchors.fill: parent
        cacheBuffer: 400
        model: CuteRadio.LanguagesModel {
            id: languageModel
            
            onStatusChanged: {
                switch (status) {
                case CuteRadio.ResourcesRequest.Loading: {
                    root.showProgressIndicator = true;
                    noResultsLabel.visible = false;
                    return;
                }
                case CuteRadio.ResourcesRequest.Error:
                    infoBanner.showMessage(errorString);
                    break;
                default:
                    break;
                }
            
                root.showProgressIndicator = false;
                noResultsLabel.visible = (count == 0);
            }
        }
        delegate: NameCountDelegate {
            onClicked: {
                appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"), {title: name, filters: {language: name}});
                appWindow.pageStack.currentPage.reload();
            }
        }
    }

    MyScrollBar {
        flickableItem: view
    }

    Label {
        id: noResultsLabel

        anchors {
            fill: parent
            margins: platformStyle.paddingLarge
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        color: platformStyle.colorNormalMid
        font.bold: true
        font.pixelSize: 32
        text: qsTr("No languages found")
        visible: false
    }
}
