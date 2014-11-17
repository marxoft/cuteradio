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
import com.nokia.symbian 1.1
import org.marxoft.cuteradio 1.0

MyPage {
    id: root

    title: qsTr("Stations by genre")
    tools: ToolBarLayout {

        BackToolButton {}

        NowPlayingButton {}

        MyToolButton {
            anchors.right: parent.right
            iconSource: "toolbar-refresh"
            toolTipText: qsTr("Reload")
            onClicked: genreModel.getGenres()
        }
    }

    MyListView {
        id: view

        anchors.fill: parent
        cacheBuffer: 400
        model: genreModel
        delegate: NameCountDelegate {
            onClicked: {
                var name = genreModel.data(index, "name");
                appWindow.pageStack.push(Qt.resolvedUrl("StationsPage.qml"), { title: name });
                stationModel.source = "genres$" + name;
                stationModel.getStationsByGenre(name);
            }
        }
        section.delegate: SectionDelegate {
            text: section
        }
        section.property: "section"
        section.criteria: ViewSection.FirstCharacter
    }

    MySectionScroller {
        listView: view
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
        text: qsTr("No genres found")
        visible: false
    }

    Connections {
        target: genreModel
        onStatusChanged: {
            switch (genreModel.status) {
            case NameCountModel.Loading: {
                root.showProgressIndicator = true;
                noResultsLabel.visible = false;
                return;
            }
            case NameCountModel.Error:
                infoBanner.showMessage(genreModel.errorString);
                break;
            default:
                break;
            }

            root.showProgressIndicator = false;
            noResultsLabel.visible = (genreModel.count == 0);
        }
    }

    Component.onCompleted: if (genreModel.count == 0) genreModel.getGenres();
}
