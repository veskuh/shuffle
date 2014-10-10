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

    MusicLibrary {
        id: musicLibrary

        onCurrentSongChanged: {
            player.jumpToNext = false
            player.source = currentSong
        }

        Component.onCompleted: player.source = currentSong
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


