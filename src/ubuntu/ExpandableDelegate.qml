/*
 * Copyright (C) 2015 Stuart Howarth <showarth@marxoft.co.uk>
 */

import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0

Expandable {
    id: root
    
    default property alias contents: collapsedContent.children
    property list<Action> actions
            
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
        }
        
        Loader {
            id: expandedLoader
            
            sourceComponent: root.expanded ? expandedComponent : undefined
        }
    }
    
    Component {
        id: expandedComponent
        
        Item {
            id: expandedContainer
            
            width: column.width
            height: expandedColumn.height
            
            Column {
                id: expandedColumn
                
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
        
                Repeater {            
                    id: repeater
            
                    function getVisibleActions() {
                        var a = [];
                
                        for (var i = 0; i < root.actions.length; i++) {
                            if (root.actions[i].visible) {
                                a.push(root.actions[i]);
                            }
                        }
                
                        return a;
                    }
            
                    model: getVisibleActions()
                           
                    Standard {
                        width: column.width
                        text: modelData.text
                        iconName: modelData.iconName
                        iconFrame: false
                        showDivider: index < (repeater.count - 1)
                        onClicked: {
                            modelData.trigger();
                            root.ListView.view.expandedIndex = -1;
                        }
                    }
                }
            }
        }
    }
}
