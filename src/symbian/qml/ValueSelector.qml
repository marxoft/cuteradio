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

ValueListItem {
    id: root

    property variant value
    property variant model
    property int selectedIndex: -1
    
    signal accepted
    signal rejected

    Loader {
        id: loader
    }

    Component {
        id: dialog

        ValueDialog {
            titleText: root.title
            model: root.model
            value: root.value
            selectedIndex: root.selectedIndex
            onSelectedIndexChanged: root.selectedIndex = selectedIndex
            onValueChanged: root.value = value
            onAccepted: root.accepted()
            onRejected: root.rejected()
        }
    }
    
    onSelectedIndexChanged: if (model) value = model.data(selectedIndex, "value");
    onValueChanged: if (model) subTitle = model.data(Math.max(0, model.match("value", value)), "name");
    onClicked: {
        loader.sourceComponent = dialog;
        loader.item.open();
    }

    Component.onCompleted: {
        if ((!value) && (model)) {
            value = model.data(Math.max(0, selectedIndex), "value");
        }
    }
}
