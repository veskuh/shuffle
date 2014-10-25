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
import QtMultimedia 5.0
import harbour.shuffle.MusicLibrary 1.0
import "pages"

ApplicationWindow
{
    id: app
    initialPage: Component { PlayPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    property bool playing: player.playbackState == MediaPlayer.PlayingState

    function togglePlay() {
        if (app.playing) player.pause()
        else player.play()
    }

    MusicLibrary {
        id: musicLibrary

        property string currentTrack
        property string currentCover
        property string currentTitle
        property string nextTrack
        property string nextCover
        property string nextTitle

        onCurrentSongChanged: {
            player.jumpToNext = false
            if (nextTrack != "") {
                currentTrack = nextTrack
                currentCover = nextCover
                currentTitle = nextTitle
            }
            nextCover = musicLibrary.cover
            nextTitle = title
            // Update track last so that all properties are correct
            nextTrack = currentSong
        }

        onCurrentTrackChanged: {
            player.source = currentTrack
        }

        Component.onCompleted: {
            next() // Load first track's info
            next() // load next track's info
        }
    }

    MediaPlayer {
        id: player
        autoLoad: true
        autoPlay: true

        property bool jumpToNext: true
        property bool failedPlay

        onStopped: {
            // Since changing source will send stop
            // we need to guard changing song again to avoid binding loop
            if (jumpToNext) {
                // In case where playback ended we play next song
                musicLibrary.next()
            }
            jumpToNext = true
        }

        onPlaying: {
            failedPlay = false
        }

        onError: {
            console.log("Failed to play" + source)
            if (!failedPlay) {
                failedPlay = true
                musicLibrary.next()
            } else {
                console.log("Stopped since two errors")
            }
        }
    }
}


