/*
Shuffle - a simple music player application
Copyright (C) 2014 Vesa-Matti Hartikainen <vesku.h@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        x: Theme.paddingLarge
        anchors.bottom: song.top
        width: parent.width - Theme.paddingLarge * 2
        color: Theme.secondaryHighlightColor
        text: player.metaData.albumArtist ? player.metaData.albumArtist : ""
        truncationMode: TruncationMode.Fade
    }

    Label {
        id: song
        anchors.centerIn: parent
        width: parent.width - Theme.paddingLarge * 2
        color: Theme.highlightColor
        text: player.metaData.title ? player.metaData.title : musicLibrary.pretifyUrl(player.source)
        maximumLineCount: 3
        wrapMode: Text.Wrap
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: !app.playing ? "image://Theme/icon-cover-play" : "image://Theme/icon-cover-pause"
            onTriggered: {
                if (app.playing) player.pause()
                else player.play()
            }
        }

        CoverAction {
            iconSource: "image://Theme/icon-cover-next-song"
            onTriggered: musicLibrary.skip()
        }
    }
}


