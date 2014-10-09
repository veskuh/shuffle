import QtQuick 2.1
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import harbour.shuffle.MusicLibrary 1.0

Page {
    id: page
    anchors.fill: parent
    property bool playing: player.playbackState == MediaPlayer.PlayingState

    MusicLibrary {
        id: musicLibrary
    }

    MediaPlayer {
        id: player
        autoLoad: true
        autoPlay: true
        source: musicLibrary.currentSong

        onStopped: musicLibrary.next()


    }

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
            }
            MenuItem {
                text: page.playing? "Pause" : "Play"
                onClicked: {
                    if (page.playing) player.pause()
                    else player.play()
                }
            }
            MenuItem {
                text: "Next"
                onClicked: {
                    musicLibrary.skip()
                }
            }
        }

        Item {
            id: coverArea
            anchors {
                top: header.bottom
                left: parent.left
            }
            width: parent.width
            height: page.height/3

            Item {
                id: dragTarget
                x:75
            }

            SongCover {
                id: eka
                dragTarget: dragTarget
                initialY: 20
                viewCenter: parent.width / 2
               // color: "red"
                centerX: dragTarget.x %480
                imageSource: "http://3.bp.blogspot.com/-QUV2tBQErcs/VDJrRmrjoiI/AAAAAAAACTk/JFO5w3mKrcY/s1600/IMG_20140930_180815.jpg"
            }

            SongCover {
                id: toka
                dragTarget: dragTarget

                initialY: 20
                viewCenter: parent.width / 2
              //  color: "green"
                centerX: (eka.centerX + 240-75)%480
                imageSource: player.metaData.coverArtUrlLarge ? player.metaData.coverArtUrlLarge : "http://3.bp.blogspot.com/-QUV2tBQErcs/VDJrRmrjoiI/AAAAAAAACTk/JFO5w3mKrcY/s1600/IMG_20140930_180815.jpg"

            }
            SongCover {
                initialY: 20
                dragTarget: dragTarget

                viewCenter: parent.width / 2
             //   color: "blue"
                centerX: (toka.centerX + 240-75)%480

               imageSource: "http://3.bp.blogspot.com/-QUV2tBQErcs/VDJrRmrjoiI/AAAAAAAACTk/JFO5w3mKrcY/s1600/IMG_20140930_180815.jpg"

            }
        }

        ShaderEffect {
            id: reflectionEffect
            anchors {
                top: coverArea.bottom
                left: parent.left
                right: parent.right
            }
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
            anchors.left: parent.left
            width: parent.width

            Column {
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingMedium
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingMedium

                Label {
                    id: artist
                    text: player.metaData.albumArtist ? player.metaData.albumArtist : ""
                    color:  Theme.secondaryColor
                    width: page.width - 2 * Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    id: song
                    text: player.metaData.title ? player.metaData.title : musicLibrary.pretifyUrl(player.source)
                    font.pixelSize: Theme.fontSizeLarge
                    width: page.width - 2 * Theme.paddingMedium
                    truncationMode: TruncationMode.Fade
                }

                Label {
                    id: album
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

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: "black"

            Column {
                height:children.height
                anchors.left: parent.left

                Slider {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: Theme.itemSizeMedium
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

                    /* There is no going back!
                    IconButton {
                        icon.source: "image://Theme/icon-m-previous"
                    }*/
                    IconButton {
                        icon.source: !page.playing ? "image://Theme/icon-m-play" : "image://Theme/icon-m-pause"
                        onClicked: {
                            if (page.playing) player.pause()
                            else player.play()
                        }
                    }
                    IconButton {
                        icon.source: "image://Theme/icon-m-next"
                        onClicked: musicLibrary.skip()
                    }

                }
            }
        }
    }
}



