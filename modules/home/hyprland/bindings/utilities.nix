{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bindd = [
      "SUPER, SPACE, Launch apps, exec, leenix-launch-walker"
      "SUPER CTRL, E, Emoji picker, exec, leenix-launch-walker -m symbols"
      "SUPER CTRL, C, Capture menu, exec, leenix-menu capture"
      "SUPER CTRL, O, Toggle menu, exec, leenix-menu toggle"
      "SUPER CTRL, H, Hardware menu, exec, leenix-menu hardware"
      "SUPER ALT, SPACE, Leenix menu, exec, leenix-menu"
      "SUPER SHIFT, code:201, Leenix menu, exec, leenix-menu"
      "SUPER, ESCAPE, System menu, exec, leenix-menu system"
      "SUPER, K, Show key bindings, exec, leenix-menu-keybindings"
      ", XF86Calculator, Calculator, exec, gnome-calculator"

      "SUPER SHIFT, SPACE, Toggle top bar, exec, leenix-toggle-waybar"
      "SUPER CTRL, SPACE, Theme background menu, exec, leenix-menu background"
      "SUPER SHIFT CTRL, SPACE, Theme menu, exec, leenix-menu theme"
      "SUPER, BACKSPACE, Toggle window transparency, exec, leenix-hyprland-window-transparency-toggle"
      "SUPER SHIFT, BACKSPACE, Toggle window gaps, exec, leenix-hyprland-window-gaps-toggle"
      "SUPER CTRL, BACKSPACE, Toggle single-window square aspect, exec, leenix-hyprland-window-single-square-aspect-toggle"

      "SUPER, COMMA, Dismiss last notification, exec, makoctl dismiss"
      "SUPER SHIFT, COMMA, Dismiss all notifications, exec, makoctl dismiss --all"
      "SUPER CTRL, COMMA, Toggle silencing notifications, exec, leenix-toggle-notification-silencing"
      "SUPER ALT, COMMA, Invoke last notification, exec, makoctl invoke"
      "SUPER SHIFT ALT, COMMA, Restore last notification, exec, makoctl restore"

      "SUPER CTRL, I, Toggle locking on idle, exec, leenix-toggle-idle"
      "SUPER CTRL, N, Toggle nightlight, exec, leenix-toggle-nightlight"
      "SUPER CTRL, Delete, Toggle laptop display, exec, leenix-hyprland-monitor-internal toggle"
      "SUPER CTRL ALT, Delete, Toggle laptop display mirroring, exec, leenix-hyprland-monitor-internal-mirror toggle"

      ", PRINT, Screenshot, exec, leenix-capture-screenshot"
      "ALT, PRINT, Screenrecording, exec, leenix-menu screenrecord"
      "SUPER, PRINT, Color picker, exec, pkill hyprpicker || hyprpicker -a"
      "SUPER CTRL, PRINT, Extract text (OCR) from screenshot, exec, leenix-capture-text-extraction"

      "SUPER CTRL, S, Share, exec, leenix-menu share"
      "SUPER CTRL, PERIOD, Transcode, exec, leenix-transcode"

      "SUPER CTRL, R, Set reminder, exec, leenix-menu reminder-set"
      "SUPER CTRL ALT, R, Show reminders, exec, leenix-reminder show"
      "SUPER SHIFT CTRL, R, Clear reminders, exec, leenix-reminder clear"

      "SUPER CTRL ALT, T, Show time, exec, notify-send -u low \"    $(date +\"%A %H:%M  ·  %d %B %Y  ·  Week %V\")\""
      "SUPER CTRL ALT, B, Show battery remaining, exec, notify-send -u low \"$(leenix-battery-status)\""
      "SUPER CTRL ALT, W, Show weather, exec, notify-send -u low \"$(leenix-weather-status)\""

      "SUPER CTRL, A, Audio controls, exec, leenix-launch-audio"
      "SUPER CTRL, B, Bluetooth controls, exec, leenix-launch-bluetooth"
      "SUPER CTRL, W, Wifi controls, exec, leenix-launch-wifi"
      "SUPER CTRL, T, Activity, exec, leenix-launch-tui btop"

      "SUPER CTRL, X, Toggle dictation, exec, voxtype record toggle"

      "SUPER CTRL, Z, Zoom in, exec, hyprctl keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float + 1')"
      "SUPER CTRL ALT, Z, Reset zoom, exec, hyprctl keyword cursor:zoom_factor 1"

      "SUPER CTRL, L, Lock system, exec, leenix-system-lock"

      ", F9, Start dictation (push-to-talk), exec, voxtype record start"
    ];

    bindld = [
      ", XF86PowerOff, Power menu, exec, leenix-menu system"
    ];

    bindl = [
      ", switch:on:Lid Switch, exec, leenix-hw-external-monitors && leenix-hyprland-monitor-internal off"
        ", switch:off:Lid Switch, exec, leenix-hyprland-monitor-internal on"
    ];

    binddr = [
      ", F9, Stop dictation (push-to-talk), exec, voxtype record stop"
    ];
  };
}
