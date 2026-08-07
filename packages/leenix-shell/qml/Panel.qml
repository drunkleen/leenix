import QtQuick
import Quickshell

PopupWindow {
  id: root

  // The offset window/item this panel hugs (normally the bar).
  required property var reference

  property int margin: 8
  property bool placeRight: true

  property bool open: false
  readonly property bool opened: root.open

  property color surface: Colors.bar
  property color border: Colors.active
  property color text: Colors.text
  property color muted: Colors.muted

  default property alias content: contentHolder.children

  function popup() { root.open = true }
  function drop() { root.open = false }
  function flip() { root.open = !root.open }

  visible: root.open
  color: "transparent"
  implicitWidth: 320
  implicitHeight: contentHolder.implicitHeight + root.margin * 2

  Rectangle {
    id: backing
    anchors.fill: parent
    color: root.surface
    radius: 8
    border.width: 1
    border.color: root.border

    Column {
      id: contentHolder
      anchors.fill: parent
      anchors.margins: root.margin
    }
  }

  anchor {
    id: powerAnchor
    window: root.reference
    adjustment: PopupAdjustment.Slide
    edges: Edges.Top | Edges.Left
    gravity: Edges.Bottom | Edges.Left
    rect.width: 1
    rect.height: 1

    onAnchoring: {
      if (!root.reference) return
      var popupWidth = root.implicitWidth
      var x
      if (root.placeRight) {
        x = root.reference.width - popupWidth - root.margin
      } else {
        x = root.margin
      }
      var y = root.reference.height + root.margin
      powerAnchor.rect.x = Math.round(x)
      powerAnchor.rect.y = Math.round(y)
    }
  }
}