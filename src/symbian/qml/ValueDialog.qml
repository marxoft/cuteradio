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

SelectionDialog {
    id: root

    property string name
    property variant value

    delegate: MenuItem {
        text: index === root.selectedIndex ? "<font color='" + ACTIVE_COLOR + "'>" + name + "</font>" : name
        onClicked: {
            root.selectedIndex = index;
            root.accept();
        }
    }
    onAccepted: if (model) value = model.data(selectedIndex, "value");
    onStatusChanged: {
        if ((status === DialogStatus.Opening) && (model) && (model.count > 0)) {
            selectedIndex = Math.max(0, model.match("value", value));
        }
    }
    onClickedOutside: reject()
}
