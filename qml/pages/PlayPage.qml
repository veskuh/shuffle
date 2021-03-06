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
import QtMultimedia 5.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: parent.height+1

        PageHeader {
            id: header
            title: "Shuffle Music"
        }

        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: pageStack.push("AboutPage.qml")
            }
            MenuItem {
                text: app.playing? "Pause" : "Play"
                onClicked: app.togglePlay()
            }

            MenuItem {
                text: "Next"
                onClicked: musicLibrary.next()
            }
        }

        Item {
            id: coverArea
            anchors.top: header.bottom
            width: parent.width
            height: page.height/3

            SongCover { position : 0 }
            SongCover { position : 1 }
            SongCover { position : 2 }
            SongCover { position : 3 }
            SongCover { position : 4 }
        }

        ShaderEffect {
            id: reflectionEffect
            anchors.top: coverArea.bottom
            width: page.width
            height: coverArea.height / 2

            property variant source: ShaderEffectSource {
                sourceItem: coverArea
            }

            property real phase

            fragmentShader: "
            uniform highp float phase;
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D source;
            void main() {
                mediump vec4 col = texture2D(source, vec2(fract(qt_TexCoord0.x+sin(phase + qt_TexCoord0.y*30.0)*0.009),
                                                     fract(1.0 - qt_TexCoord0.y+sin(phase + qt_TexCoord0.x*15.0)*0.01)));
                gl_FragColor = mix(col,vec4(0.0,0.0,0.0,1.0),1.0 - qt_TexCoord0.y);
            }"

            NumberAnimation on phase {
                running: true
                loops: Animation.Infinite
                from: 0
                to: 2 * Math.PI
                duration: 3000
            }
        }

        Rectangle {
            color: "black"
            anchors.top: reflectionEffect.bottom
            anchors.bottom: tools.top
            width: parent.width

            Column {
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium

                Label {
                    text: player.metaData.albumArtist ? player.metaData.albumArtist : ""
                    color:  Theme.secondaryColor
                    width: page.width - 2 * Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    text: player.metaData.title ? player.metaData.title : musicLibrary.currentTitle
                    font.pixelSize: Theme.fontSizeLarge
                    width: page.width - 2 * Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    text: player.metaData.albumTitle ? player.metaData.albumTitle : ""
                    color: Theme.secondaryColor
                    width: page.width - 2 * Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }
            }
        }

        Rectangle {
            id: tools
            height: Theme.itemSizeMedium * 2
            width: parent.width
            anchors.bottom: parent.bottom
            color: "black"

            Column {
                height:children.height

                Slider {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: page.width
                    handleVisible: false
                    minimumValue: 0
                    maximumValue: player.duration
                    value: player.position
                    enabled: false
                }
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: Theme.itemSizeMedium
                    spacing: Theme.paddingLarge

                    IconButton {
                        icon.source: !app.playing ? "image://Theme/icon-m-play" : "image://Theme/icon-m-pause"
                        onClicked: app.togglePlay()
                    }
                    IconButton {
                        icon.source: "image://Theme/icon-m-next"
                        onClicked: musicLibrary.next()
                    }
                }
            }
        }
    }
}
