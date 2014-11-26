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
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/nokia/meego/UIConstants.js" as UI

MyPage {
    id: root

    title: qsTr("Changelog")
    tools: ToolBarLayout {
        BackToolIcon {}

        NowPlayingButton {}
    }

    Flickable {
        id: flicker

        anchors {
            fill: parent
            topMargin: UI.PADDING_DOUBLE
        }
        contentWidth: width
        contentHeight: column.height + UI.PADDING_DOUBLE
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column

            anchors {
                left: parent.left
                leftMargin: UI.PADDING_DOUBLE
                right: parent.right
                rightMargin: UI.PADDING_DOUBLE
                top: parent.top
            }
            spacing: UI.PADDING_DOUBLE
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.3.3</b>

<ul>

<li>
Improve retrieval of stream URLs from playlists.
</li>

<li>
Re-fetch the stream URL from playlists when resuming playback to avoid errors due to URL changes.
</li>

</ul>

</html>"
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.3.0</b>

<ul>

<li>
Replace TuneIn with cuteRadio REST API.
</li>

</ul>

</html>"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.2.2</b>

<ul>

<li>
Fix search.
</li>

<li>
Fix description text display in list delegates.
</li>

<li>
Disable predictive text in source fields.
</li>

</ul>

</html>"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.2.1</b>

<ul>

<li>
Simplify station browsing.
</li>

<li>
Improve state-change notifications in the media player.
</li>

</ul>

</html>"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.2.0</b>

<ul>

<li>
Added TuneIn integration.
</li>

<li>
Added podcasts.
</li>

<li>
Added option to play a station direct from a URL.
</li>

<li>
Added option to use an alternative media player.
</li>

<li>
Replaced 'Now playing' banner with a toolbutton.
</li>

</ul>

</html>"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.1.2</b>

<ul>

<li>
Added option to clear 'now playing' by swiping down the popup.
</li>

<li>
Fixed adding of stations to the database.
</li>

<li>
Other minor bug fixes.
</li>

</ul>

</html>"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.1.0</b>

<ul>

<li>
Added option to set a network proxy.
</li>

<li>
Minor bug fixes.
</li>

</ul>

</html>"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.0.1</b>

<ul>

<li>
Initial release.
</li>

</ul>

</html>"
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
