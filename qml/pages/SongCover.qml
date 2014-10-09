import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: cover

    property int viewCenter: 0
    property int centerX: 0
    property int initialY: 0
    property int distance: (viewCenter - Math.abs((centerX) - viewCenter))
    property Item dragTarget

    property alias imageSource: image.source

    Image {
        id:image
        source:""
        anchors.fill: parent
        visible: source !== ""
        fillMode: Image.PreserveAspectCrop
        smooth: true
        clip: true
        opacity: cover.opacity
    }

    opacity: (distance / viewCenter) * 0.9 + 0.1
    width:100 * (1.0 + 0.47* (distance/viewCenter))
    height:width
    y: initialY + distance / 2
    x: centerX - width / 2

    MouseArea {
        id: mousearea
        anchors.fill: parent
        drag {
           axis: Drag.XAxis
           target: cover.dragTarget
        }
    }
}





