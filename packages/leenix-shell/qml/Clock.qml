import QtQuick
import Quickshell
import QtQuick.Layouts

RowLayout {
  id: clock
  spacing: 10
  Layout.alignment: Qt.AlignVCenter

  SystemClock {
    id: systemClock
    enabled: true
    precision: SystemClock.Minutes
  }

  Text {
    text: Qt.formatTime(systemClock.date, "HH:mm")
    font.pixelSize: 13
    font.weight: Font.Medium
    color: Colors.text
  }

  Text {
    text: Qt.formatDate(systemClock.date, "ddd dd.MM")
    font.pixelSize: 11
    color: Colors.muted
  }
}