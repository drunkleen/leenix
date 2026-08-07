import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  required property string text
  property string command: ""
  property color foreground: Colors.text
  signal activated

  implicitWidth: 288
  implicitHeight: 36

  Process {
    id: commandProcess
    command: root.command !== "" ? [root.command] : []
  }

  Rectangle {
    id: rect
    anchors.fill: parent
    radius: 6
    color: tapHandler.hovered || tapHandler.pressed ? Colors.active : Colors.bar
    border.width: 1
    border.color: tapHandler.hovered ? Colors.accent : "transparent"

    Text {
      anchors.fill: parent
      anchors.leftMargin: 12
      anchors.rightMargin: 12
      text: root.text
      verticalAlignment: Text.AlignVCenter
      font.pixelSize: 13
      color: root.foreground
    }
  }

  TapHandler {
    id: tapHandler
    onTapped: {
      if (root.command !== "") commandProcess.start()
      root.activated()
    }
  }
}