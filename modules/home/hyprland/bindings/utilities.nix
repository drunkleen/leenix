{ lib, ... }:

let
  binds = [
    # Launchers / menus
    {
      keys = "SUPER + SPACE";
      description = "Launch apps";
      command = "leenix-launch-walker";
    }
    {
      keys = "SUPER + CTRL + E";
      description = "Emoji picker";
      command = "leenix-launch-walker -m symbols";
    }
    {
      keys = "SUPER + CTRL + C";
      description = "Capture menu";
      command = "leenix-menu capture";
    }
    {
      keys = "SUPER + CTRL + O";
      description = "Toggle menu";
      command = "leenix-menu toggle";
    }
    {
      keys = "SUPER + CTRL + H";
      description = "Hardware menu";
      command = "leenix-menu hardware";
    }
    {
      keys = "SUPER + ALT + SPACE";
      description = "Leenix menu";
      command = "leenix-menu";
    }
    {
      keys = "SUPER + SHIFT + code:201";
      description = "Leenix menu";
      command = "leenix-menu";
    }
    {
      keys = "SUPER + ESCAPE";
      description = "System menu";
      command = "leenix-menu system";
    }
    {
      keys = "SUPER + K";
      description = "Show key bindings";
      command = "leenix-menu-keybindings";
    }
    {
      keys = "XF86Calculator";
      description = "Calculator";
      command = "gnome-calculator";
    }

    # UI / appearance
    {
      keys = "SUPER + SHIFT + SPACE";
      description = "Toggle top bar";
      command = "leenix-toggle-waybar";
    }
    {
      keys = "SUPER + CTRL + SPACE";
      description = "Wallpaper picker";
      command = "leenix-wallpaper-switcher";
    }
    {
      keys = "SUPER + SHIFT + CTRL + SPACE";
      description = "Theme menu";
      command = "leenix-menu theme";
    }
    {
      keys = "SUPER + BACKSPACE";
      description = "Toggle window transparency";
      command = "leenix-hyprland-window-transparency-toggle";
    }
    {
      keys = "SUPER + SHIFT + BACKSPACE";
      description = "Toggle window gaps";
      command = "leenix-hyprland-window-gaps-toggle";
    }
    {
      keys = "SUPER + CTRL + BACKSPACE";
      description = "Toggle single-window square aspect";
      command = "leenix-hyprland-window-single-square-aspect-toggle";
    }

    # Notifications
    {
      keys = "SUPER + COMMA";
      description = "Dismiss last notification";
      command = "makoctl dismiss";
    }
    {
      keys = "SUPER + SHIFT + COMMA";
      description = "Dismiss all notifications";
      command = "makoctl dismiss --all";
    }
    {
      keys = "SUPER + CTRL + COMMA";
      description = "Toggle silencing notifications";
      command = "leenix-toggle-notification-silencing";
    }
    {
      keys = "SUPER + ALT + COMMA";
      description = "Invoke last notification";
      command = "makoctl invoke";
    }
    {
      keys = "SUPER + SHIFT + ALT + COMMA";
      description = "Restore last notification";
      command = "makoctl restore";
    }

    # Display / idle
    {
      keys = "SUPER + CTRL + I";
      description = "Toggle locking on idle";
      command = "leenix-toggle-idle";
    }
    {
      keys = "SUPER + CTRL + N";
      description = "Toggle nightlight";
      command = "leenix-toggle-nightlight";
    }
    {
      keys = "SUPER + CTRL + DELETE";
      description = "Toggle laptop display";
      command = "leenix-hyprland-monitor-internal toggle";
    }
    {
      keys = "SUPER + CTRL + ALT + DELETE";
      description = "Toggle laptop display mirroring";
      command = "leenix-hyprland-monitor-internal-mirror toggle";
    }

    # Capture
    {
      keys = "PRINT";
      description = "Screenshot";
      command = "leenix-capture-screenshot";
    }
    {
      keys = "ALT + PRINT";
      description = "Screenrecording";
      command = "leenix-menu screenrecord";
    }
    {
      keys = "SUPER + PRINT";
      description = "Color picker";
      command = "pkill hyprpicker || hyprpicker -a";
    }
    {
      keys = "SUPER + CTRL + PRINT";
      description = "Extract text (OCR) from screenshot";
      command = "leenix-capture-text-extraction";
    }

    # Share / transcode
    {
      keys = "SUPER + CTRL + S";
      description = "Share";
      command = "leenix-menu share";
    }
    {
      keys = "SUPER + CTRL + PERIOD";
      description = "Transcode";
      command = "leenix-transcode";
    }

    # Reminders
    {
      keys = "SUPER + CTRL + R";
      description = "Set reminder";
      command = "leenix-menu reminder-set";
    }
    {
      keys = "SUPER + CTRL + ALT + R";
      description = "Show reminders";
      command = "leenix-reminder show";
    }
    {
      keys = "SUPER + SHIFT + CTRL + R";
      description = "Clear reminders";
      command = "leenix-reminder clear";
    }

    # Status
    {
      keys = "SUPER + CTRL + ALT + T";
      description = "Show time";
      command = ''notify-send -u low "    $(date +"%A %H:%M  ·  %d %B %Y  ·  Week %V")"'';
    }
    {
      keys = "SUPER + CTRL + ALT + B";
      description = "Show battery remaining";
      command = ''notify-send -u low "$(leenix-battery-status)"'';
    }
    {
      keys = "SUPER + CTRL + ALT + W";
      description = "Show weather";
      command = ''notify-send -u low "$(leenix-weather-status)"'';
    }

    # Controls
    {
      keys = "SUPER + CTRL + A";
      description = "Audio controls";
      command = "leenix-launch-audio";
    }
    {
      keys = "SUPER + CTRL + B";
      description = "Bluetooth controls";
      command = "leenix-launch-bluetooth";
    }
    {
      keys = "SUPER + CTRL + W";
      description = "Wifi controls";
      command = "leenix-launch-wifi";
    }
    {
      keys = "SUPER + CTRL + T";
      description = "Activity";
      command = "leenix-launch-tui btop";
    }

    # Dictation
    {
      keys = "SUPER + CTRL + X";
      description = "Toggle dictation";
      command = "voxtype record toggle";
    }

    # Zoom
    {
      keys = "SUPER + CTRL + Z";
      description = "Zoom in";
      command = "leenix-hypr-zoom in";
    }
    {
      keys = "SUPER + CTRL + ALT + Z";
      description = "Reset zoom";
      command = "leenix-hypr-zoom reset";
    }

    # System
    {
      keys = "SUPER + CTRL + L";
      description = "Lock system";
      command = "leenix-system-lock";
    }

    # Push-to-talk: press
    {
      keys = "F9";
      description = "Start dictation (push-to-talk)";
      command = "voxtype record start";
    }
  ];

  lockedBinds = [
    {
      keys = "XF86PowerOff";
      description = "Power menu";
      command = "leenix-menu system";
    }
  ];

  lockedNoDescriptionBinds = [
    {
      keys = "switch:on:Lid Switch";
      command = "leenix-hw-external-monitors && leenix-hyprland-monitor-internal off";
    }
    {
      keys = "switch:off:Lid Switch";
      command = "leenix-hyprland-monitor-internal on";
    }
  ];

  releaseBinds = [
    # Push-to-talk: release
    {
      keys = "F9";
      description = "Stop dictation (push-to-talk)";
      command = "voxtype record stop";
    }
  ];

  bindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command}),
          {
            description = ${builtins.toJSON bind.description}
          }
        )
      '')
      binds;

  lockedBindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command}),
          {
            locked = true,
            description = ${builtins.toJSON bind.description}
          }
        )
      '')
      lockedBinds;

  lockedNoDescriptionBindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command}),
          {
            locked = true
          }
        )
      '')
      lockedNoDescriptionBinds;

  releaseBindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command}),
          {
            release = true,
            description = ${builtins.toJSON bind.description}
          }
        )
      '')
      releaseBinds;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${bindLines}

    ${lockedBindLines}

    ${lockedNoDescriptionBindLines}

    ${releaseBindLines}
  '';
}
