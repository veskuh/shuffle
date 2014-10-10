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


