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
 
import org.hildon.components 1.0
import org.marxoft.cuteradio 1.0

Dialog {
    id: root
    
    height: window.inPortrait ? 680 : 360
    windowTitle: qsTr("Search")
    content: Column {
        id: column
        
        anchors.fill: parent
        
        TextField {
            id: searchField
            
            placeholderText: qsTr("Search query")
            validator: RegExpValidator {
                regExp: /^.+/
            }
            onReturnPressed: root.accept()
        }
        
        ListView {
            id: view
            
            focusPolicy: Qt.NoFocus
            horizontalScrollMode: ListView.ScrollPerItem
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            minimumHeight: Math.min(searchModel.count * 70, 240)
            model: SortFilterProxyModel {
                id: filterModel
                
                sourceModel: NameCountModel {
                    id: searchModel
                    
                    onStatusChanged: {
                        switch (status) {
                        case NameCountModel.Loading: {
                            root.showProgressIndicator = true;
                            noResultsLabel.visible = false;
                            return;
                        }
                        case NameCountModel.Error:
                            infobox.showError(searchModel.errorString);
                            break;
                        default:
                            break;
                        }
                        
                        root.showProgressIndicator = false;
                        noResultsLabel.visible = (searchModel.count == 0);
                    }
                }
                filterProperty: "name"
                filterRegExp: searchField.text ? eval("(/" + searchField.text + "/gi)") : undefined
                dynamicSortFilter: true
            }
            delegate: SearchDelegate {}
            onClicked: {
                searchField.text = searchModel.data(QModelIndex.row(filterModel.mapToSourceModelIndex(currentIndex)), "name");
                currentIndex = QModelIndex.parent(currentIndex);
            }
            
            Label {
                id: noResultsLabel
                
                anchors.fill: parent
                alignment: Qt.AlignCenter
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.disabledTextColor
                text: qsTr("No searches found")
                visible: false
            }
        }
    }
    
    buttons: Button {
        focusPolicy: Qt.NoFocus
        text: qsTr("Done")
        enabled: searchField.acceptableInput
        onClicked: root.accept()
    }
    
    onAccepted: pageStack.push(Qt.resolvedUrl("SearchPage.qml"), { query: searchField.text })
    onVisibleChanged: {
        if (visible) {
            searchField.clear();
            searchField.focus = true;
            searchModel.getSearches();
        }
    }
}
