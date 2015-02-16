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
import Ubuntu.Components.ListItems 1.0 as ListItem
import org.marxoft.cuteradio 1.0

Popover {
    id: root
    
    UbuntuListView {
        id: view
        
        height: units.gu(24)
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
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
        header: ListItem.Header {
            text: i18n.tr("Previous searches")
        }
        delegate: ListItem.Standard {
            text: name
            onClicked: {
                PopupUtils.close(root);
                pageStack.push(Qt.resolvedUrl("SearchPage.qml"), { query: searchModel.data(index, "name") });
            }
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
            text: i18n.tr("No searches found")
            visible: false
        }
    
        ActivityIndicator {
            id: progressIndicator
        
            anchors.centerIn: parent
            running: visible
            visible: false
        }
    }
    
    Component.onCompleted: searchModel.getSearches()
}
