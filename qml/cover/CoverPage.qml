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

    Image {
        y: Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0.4
        visible: coverImage.source == ""
        source: "/usr/share/icons/hicolor/86x86/apps/shuffle.png"
    }

    Image {
        id: coverImage
        width: parent.width
        height: width
        source: musicLibrary.currentCover
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        width: parent.width
        height: width
        anchors.centerIn: parent

        gradient: Gradient {
              GradientStop { position: 0.0; color: "transparent" }
              GradientStop { position: 0.7; color: "#BA000000" }
              GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Label {
        id: song
        anchors.bottom: artist.top
        width: parent.width - Theme.paddingLarge * 2
        x: Theme.paddingLarge
        color: Theme.primaryColor
        text: player.metaData.title ? player.metaData.title : musicLibrary.pretifyUrl(player.source)
        maximumLineCount: 3
        wrapMode: Text.Wrap
        truncationMode: TruncationMode.Elide
    }

    Label {
        id: artist
        x: Theme.paddingLarge
        anchors.top: coverImage.bottom
        width: parent.width - Theme.paddingLarge * 2
        color: Theme.secondaryColor
        text: player.metaData.albumArtist ? player.metaData.albumArtist : ""
        truncationMode: TruncationMode.Elide
        font.pixelSize: Theme.fontSizeExtraSmall
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: !app.playing ? "image://Theme/icon-cover-play" : "image://Theme/icon-cover-pause"
            onTriggered: app.togglePlay()
        }

        CoverAction {
            iconSource: "image://Theme/icon-cover-next-song"
            onTriggered: musicLibrary.next()
        }
    }
}


