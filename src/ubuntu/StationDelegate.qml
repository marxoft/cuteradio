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
import Ubuntu.Components.ListItems 1.0

Expandable {
    id: root
    
    property alias menuItems: repeater.model
    
    signal menuItemClicked(int menuIndex)
    
    expandedHeight: column.height + units.gu(1)
        
    Column {
        id: column
        
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        
        Item {
            id: collapsedContent
            
            width: parent.width
            height: root.collapsedHeight
            
            Item {
                id: labelContainer
                
                height: childrenRect.height
                anchors {
                    left: parent.left
                    right: loader.sourceComponent ? loader.left : parent.right
                    rightMargin: loader.sourceComponent ? units.gu(1) : 0
                    verticalCenter: parent.verticalCenter
                }
                
                Label {
                    id: titleLabel
                    
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }
                    elide: Text.ElideRight
                    fontSize: "medium"
                    color: root.selected ? UbuntuColors.orange : Theme.palette.selected.backgroundText
                    text: title
                }

                Label {
                    id: subtitleLabel
                    
                    anchors {
                        top: titleLabel.bottom
                        left: parent.left
                        right: parent.right
                    }
                    elide: Text.ElideRight
                    fontSize: "small"
                    color: root.selected ? UbuntuColors.orange : Theme.palette.normal.backgroundText
                    text: genre + " | " + country + " | " + language
                }
            }

            Loader {
                id: loader

                width: Math.floor(parent.height / 2)
                height: width
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                sourceComponent: is_favourite ? icon : undefined
            }

            Component {
                id: icon

                Icon {
                    name: "like"
                }
            }
        }
        
        Repeater {
            id: repeater
                        
            Standard {
                width: column.width
                text: modelData.text
                iconName: modelData.iconName
                iconFrame: false
                onClicked: root.menuItemClicked(index)
            }
        }
    }
}
