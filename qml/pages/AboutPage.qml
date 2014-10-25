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

import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: page
    Column {
        spacing: Theme.paddingMedium

        PageHeader {
            width: page.width
            title: "About Shuffle"
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/usr/share/icons/hicolor/86x86/apps/shuffle.png"
        }


        Label {
            width: page.width - 2 * Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter

            text: "Shuffle is a simple and clean music player application " +
                  "for playing songs from your music library in random order."
            wrapMode: Text.WordWrap
            color: Theme.highlightColor
        }

        SectionHeader {
            width: page.width - 2 * Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Author"
            color: Theme.highlightColor
        }

        Label {
            width: page.width - 2 * Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Vesa-Matti Hartikainen<br>Email: vesku.h@gmail.com<br>Twitter: @veskuh"
            wrapMode: Text.WordWrap
            color: Theme.highlightColor
        }

        SectionHeader {
            width: page.width - 2 * Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            text: "License"
        }

        Label {
            width: page.width - 2 * Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
            text: "Shuffle is open source and licensed under GPLv2.1 or later."
            color: Theme.highlightColor
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Sources"
            onClicked: Qt.openUrlExternally("http://github.com/veskuh/shuffle")
        }
    }
}
