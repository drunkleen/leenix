import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// Root is the PanelWindow itself (NOT an Item): Quickshell 0.3.0 wraps a
// QQuickItem config root in a FloatingWindowInterface, spawning an unwanted
// normal XDG toplevel client (the "white window"). A PanelWindow root avoids
// that wrapper entirely.
PanelWindow {
  id: root

  visible: root.loaded
  anchors {
    left: true
    right: true
    top: true
    bottom: true
  }
  WlrLayershell.namespace: "leenix-wallpaper-picker"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  color: "transparent"

  readonly property string rowsFile: Quickshell.env("LEENIX_WALLPAPER_ROWS_FILE")
  readonly property string selectionFile: Quickshell.env("LEENIX_WALLPAPER_SELECTION_FILE")
  readonly property string currentWallpaper: Quickshell.env("LEENIX_WALLPAPER_CURRENT")
  property bool loaded: false

  readonly property color bgColor: "#11191c"
  readonly property color panelColor: "#0f1517"
  readonly property color borderColor: "#223033"
  readonly property color fgColor: "#d8e3e0"
  readonly property color accentColor: "#33b8a8"
  readonly property color edgeLight: "#59d6c5"

  ListModel { id: wallpapers }

  function fileUrl(path) {
    return "file://" + encodeURIComponent(path).replace(/%2F/g, "/")
  }

  function loadRows(raw) {
    wallpapers.clear()
    var lines = raw.split("\n")
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i]
      if (!line) continue
      var parts = line.split("\t")
      if (parts.length < 3) continue
      wallpapers.append({ path: parts[0], thumb: parts[1], resolved: parts[2] })
    }
    root.loaded = wallpapers.count > 0
    grid.currentIndex = currentIndexForSelection()
    grid.forceActiveFocus()
  }

  function currentIndexForSelection() {
    if (root.currentWallpaper.length === 0) return 0
    for (var i = 0; i < wallpapers.count; i++) {
      if (wallpapers.get(i).resolved === root.currentWallpaper) return i
    }
    return 0
  }

  function isCurrent(index) {
    return index >= 0 && index < wallpapers.count &&
      root.currentWallpaper.length > 0 &&
      wallpapers.get(index).resolved === root.currentWallpaper
  }

  function applyCurrent() {
    if (grid.currentIndex < 0 || grid.currentIndex >= wallpapers.count) return
    commitProc.command = [
      "sh", "-c", 'printf "%s\\n" "$1" > "$2"',
      "sh", wallpapers.get(grid.currentIndex).path, root.selectionFile
    ]
    commitProc.running = true
  }

  function cancel() {
    Qt.quit()
  }

  Process {
    id: commitProc
    onExited: Qt.quit()
  }

  Process {
    id: rowsProc
    command: ["base64", "-d", root.rowsFile]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.loadRows(String(text || ""))
    }
  }

  Component.onCompleted: rowsProc.running = true

  Rectangle {
    anchors.fill: parent
    color: "#0b1113"
    opacity: 0.72
  }

  Rectangle {
    id: card
    anchors.centerIn: parent
    width: 860
    height: 560
    radius: 0
    border.width: 2
    border.color: root.borderColor
    color: root.bgColor

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 18
      spacing: 12

      Text {
        text: "Choose Wallpaper"
        color: root.fgColor
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 18
        font.bold: true
      }

      Text {
        text: "Enter: apply    Arrow keys: navigate    Esc: cancel"
        color: root.edgeLight
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 11
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: root.panelColor
        border.width: 1
        border.color: root.borderColor
        clip: true

        GridView {
          id: grid
          anchors.fill: parent
          anchors.margins: 10
          model: wallpapers
          cellWidth: 200
          cellHeight: 126
          clip: true
          focus: true
          keyNavigationWraps: true

          Keys.onReturnPressed: root.applyCurrent()
          Keys.onEnterPressed: root.applyCurrent()
          Keys.onEscapePressed: root.cancel()

          // Inline delegate: a root-level Component is mis-handled by
          // Quickshell 0.3.0 and spawns a normal XDG toplevel client.
          delegate: Rectangle {
            width: grid.cellWidth - 12
            height: grid.cellHeight - 12
            radius: 0
            border.width: (grid.currentIndex === index || root.isCurrent(index)) ? 2 : 1
            border.color: (grid.currentIndex === index || root.isCurrent(index))
              ? root.accentColor : root.borderColor
            color: root.panelColor

            Image {
              anchors.fill: parent
              anchors.margins: 3
              source: root.fileUrl(thumb)
              fillMode: Image.PreserveAspectCrop
              asynchronous: true
              cache: true
              mipmap: true
            }

            MouseArea {
              anchors.fill: parent
              onClicked: {
                grid.currentIndex = index
                root.applyCurrent()
              }
            }
          }
        }
      }
    }
  }
}
