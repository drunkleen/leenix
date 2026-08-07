import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
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

  Panel {
    id: powerPanel
    reference: bar
    placeRight: true
    open: false

    content: [
      PanelButton {
        text: "Lock"
        command: "loginctl lock-session"
        onActivated: powerPanel.drop()
      },
      PanelButton {
        text: "Suspend"
        command: "systemctl suspend"
        onActivated: powerPanel.drop()
      },
      PanelButton {
        text: "Reboot"
        command: "systemctl reboot"
        onActivated: powerPanel.drop()
      },
      PanelButton {
        text: "Shut Down"
        command: "systemctl poweroff"
        onActivated: powerPanel.drop()
      }
    ]
  }

  IpcHandler {
    target: "shell"

    function ping(): string { return "ok" }
    function toggle(panel: string): void {
      if (panel === "power") powerPanel.flip()
    }
    function open(panel: string): void {
      if (panel === "power") powerPanel.popup()
    }
    function close(panel: string): void {
      if (panel === "power") powerPanel.drop()
    }
  }
}