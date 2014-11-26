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

MyPage {
    id: root

    title: qsTr("Changelog")
    orientationLock: Settings.screenOrientation
    tools: ToolBarLayout {
        BackToolButton {}

        NowPlayingButton {}
    }

    MyFlickable {
        id: flicker

        anchors.fill: parent
        contentHeight: column.height + platformStyle.paddingLarge * 2
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: platformStyle.paddingLarge
            }
            spacing: platformStyle.paddingLarge * 2
            
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

</ul>

</html>"
            }
            
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                text: "<html>
<b>0.3.2</b>

<ul>

<li>
Fix SSL handshake errors on some devices.
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

<li>
Add in-app updates.
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
Added TuneIn integration.
</li>

<li>
Added podcasts.
</li>

<li>
Added option to play a station direct from a URL.
</li>

<li>
Improve state-change notifications in the media player.
</li>

<li>
Added option to use an alternative media player.
</li>

<li>
Replaced 'Now playing' banner with a toolbutton.
</li>

<li>
New icon designed by Matthew Kuhl.
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
Fixed initialisation of the volume control.
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
<b>0.1.1</b>

<ul>

<li>
Initial release.
</li>

</ul>

</html>"
            }
        }
    }

    MyScrollBar {
        flickableItem: flicker
    }
}
