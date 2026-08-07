import QtQuick
import Quickshell.Services.SystemTray
import QtQuick.Layouts

RowLayout {
  id: tray
  spacing: 4

  Repeater {
    model: SystemTray.items

    Item {
      id: trayItem
      required property var modelData
      width: 28
      height: 28
      Layout.alignment: Qt.AlignVCenter

      Rectangle {
        id: background
        anchors.fill: parent
        radius: 6
        color: control.containsMouse ? Colors.active : "transparent"

        Behavior on color { ColorAnimation { duration: 120 } }
      }

      Image {
        anchors.fill: parent
        anchors.margins: 5
        source: trayItem.modelData.icon
        sourceSize.width: 18
        sourceSize.height: 18
        fillMode: Image.PreserveAspectFit
      }

      MouseArea {
        id: control
        anchors.fill: parent
        hoverEnabled: true
        onClicked: trayItem.modelData.activate()
      }
    }
  }
}