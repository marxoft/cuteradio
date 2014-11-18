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

SelectionDialog {
    id: root

    property string name
    property variant value

    onAccepted: {
        name = model.name(selectedIndex);
        value = model.value(selectedIndex);
    }

    delegate: MenuItem {
        text: index === root.selectedIndex ? "<font color='" + Settings.activeColor + "'>" + name + "</font>" : name
        onClicked: {
            root.selectedIndex = index;
            root.accept();
        }
    }
    onStatusChanged:  {
        if (status === DialogStatus.Open) {
            for (var i = 0; i < model.count; i++) {
                if (model.value(i) === value) {
                    name = model.name(i);
                    selectedIndex = i;

                    return;
                }
            }
        }
    }
    onClickedOutside: reject()
}
