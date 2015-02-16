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

import QtQuick 2.0
import Ubuntu.Components 1.1
import org.marxoft.cuteradio 1.0

Page {
    id: root

    title: i18n.tr("Stations by genre")
    head.actions: [
		SettingsAction {},
        
        PlayUrlAction {},
        
        NowPlayingAction {}
    ]

    UbuntuListView {
        id: view

        anchors.fill: parent
        cacheBuffer: 400
        model: genreModel
		pullToRefresh.enabled: true
        delegate: NameCountDelegate {
            onClicked: {
                var name = genreModel.data(index, "name");
                pageStack.push(Qt.resolvedUrl("StationsPage.qml"), { title: name });
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
	
	Scrollbar {
		id: scrollBar
		
		flickableItem: view
	}

    Label {
        id: noResultsLabel
        
        anchors {
            fill: parent
            margins: units.gu(1)
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        text: i18n.tr("No genres found")
        visible: false
    }

    Connections {
        target: genreModel
        onStatusChanged: {
            switch (genreModel.status) {
            case NameCountModel.Loading: {
                view.pullToRefresh.refreshing = true;
                noResultsLabel.visible = false;
                return;
            }
            case NameCountModel.Error:
                infoBanner.showMessage(genreModel.errorString);
                break;
            default:
                break;
            }
            
            view.pullToRefresh.refreshing = false;
            noResultsLabel.visible = (genreModel.count == 0);
        }
    }
	
	Connections {
		target: view.pullToRefresh
		onRefresh: genreModel.getGenres()
	}
    
    Component.onCompleted: if (genreModel.count == 0) genreModel.getGenres();
}