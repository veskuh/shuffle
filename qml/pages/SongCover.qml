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

Item {
    id: cover

    property string title
    property string artist
    property string imageSource
    property int position

    scale: position != 2 ? 0.5 : 1.0
    x: -width + position * (parent.width - 3 * width) / 4 + position * width
    y: Theme.paddingLarge
    width: parent.width / 2 - Theme.paddingMedium * 2
    height: width

    Image {
        id:image
        source: imageSource != "" ? imageSource : "image://Theme/icon-l-music"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        smooth: true
        clip: true
        opacity: imageSource == "" ? 0.3 : 1.0
    }

    Label {
        x: Theme.paddingMedium
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        text: title
        width: cover.width - Theme.paddingMedium * 2
        truncationMode: TruncationMode.Elide
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.highlightColor
        maximumLineCount: 3
        wrapMode: Text.Wrap
        visible: imageSource == ""
        horizontalAlignment: Text.AlignHCenter
    }

    Behavior on scale {
        NumberAnimation { duration: 1000 }
    }

    Behavior on x {
        enabled: position != 0
        NumberAnimation {
            duration: 1000; easing.type: Easing.InOutCubic
        }
    }

    Connections {
        target: musicLibrary
        onNextTrackChanged: cover.position = cover.position == 0 ? 4 : cover.position - 1
    }

    Component.onCompleted: {
        if (position == 2) {
            title = musicLibrary.pretifyUrl(musicLibrary.currentTrack)
            imageSource = musicLibrary.currentCover
        } else if (position == 3) {
            title = musicLibrary.pretifyUrl(musicLibrary.nextTrack)
            imageSource = musicLibrary.nextCover
        }
    }

   onPositionChanged: {
        if (cover.position == 3) {
            title = musicLibrary.pretifyUrl(musicLibrary.nextTrack)
            imageSource = musicLibrary.nextCover
        }
    }
}





