import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
  id: root

  PanelWindow {
    id: bar
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 36
    visible: true
    aboveWindows: true
    exclusiveZone: height
    exclusionMode: ExclusionMode.Normal

    color: Colors.bar

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 12
      anchors.rightMargin: 12
      spacing: 8

      Workspaces {}

      Text {
        text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
        elide: Text.ElideMiddle
        font.pixelSize: 12
        color: Colors.muted
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
      }

      Tray {}

      Clock {}
    }
  }
}