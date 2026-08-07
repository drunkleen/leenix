import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts

RowLayout {
  id: workspaces
  spacing: 4

  Repeater {
    model: Hyprland.workspaces

    Item {
      id: workspaceButton
      required property var modelData

      width: 34
      height: 28
      Layout.alignment: Qt.AlignVCenter

      Rectangle {
        anchors.fill: parent
        radius: 6
        color: modelData.focused ? Colors.active : "transparent"
        border.width: modelData.focused ? 1 : 0
        border.color: modelData.focused ? Colors.accent : Colors.muted
        opacity: modelData.focused ? 1 : 0.4

        Text {
          anchors.centerIn: parent
          text: modelData.id.toString()
          font.pixelSize: 13
          font.weight: Font.DemiBold
          color: modelData.focused ? Colors.text : Colors.muted
        }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("workspace", modelData.id.toString())
      }
    }
  }
}