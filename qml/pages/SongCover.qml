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

    property int viewCenter: 0
    property int centerX: 0
    property int initialY: 0
    property int distance: (viewCenter - Math.abs((centerX) - viewCenter))
    property Item dragTarget

    property string title
    property string artist

    property string imageSource

    Image {
        id:image
        source: imageSource != "" ? imageSource : "image://Theme/icon-l-music"
        anchors.fill: parent
        visible: source !== ""
        fillMode: Image.PreserveAspectCrop
        smooth: true
        clip: true
        opacity: imageSource == "" ? 0.3 : 1.0
    }

    opacity: (distance / viewCenter) * 0.9 + 0.1
    width:100 * (1.0 + 0.47* (distance/viewCenter))
    height:width
    y: initialY + distance / 2
    x: centerX - width / 2


    Label {
        x: Theme.paddingMedium
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium

        text: title
        width: cover.width - Theme.paddingMedium * 2
        truncationMode: TruncationMode.Elide
        font.pixelSize: Theme.fontSizeTiny

        maximumLineCount: 3
        wrapMode: Text.Wrap

    }


    MouseArea {
        id: mousearea
        anchors.fill: parent
        drag {
           axis: Drag.XAxis
           target: cover.dragTarget
        }
    }
}





