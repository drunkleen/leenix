{
  lib,
  pkgs,
  ...
}:

let
  scripts = import ./scripts { inherit pkgs; };
in
{
  programs.waybar = {
    enable = true;

    # waybar 0.15.0 prints the raw battery status (e.g. "Charging") to stdout on
    # every battery update via `puts(status.c_str())` in src/modules/battery.cpp.
    # This is the source of the repeated "Charging" output. Fixed upstream in
    # commit bd222984; the patch mirrors that fix for the pinned 0.15.0 build.
    package = pkgs.waybar.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./battery-stdout-fix.patch ];
    });

    settings.mainBar = {
      reload_style_on_change = true;
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;

      modules-left = [
        "custom/leenix"
        "hyprland/workspaces"
      ];
      modules-center = [
        "clock"
        "custom/weather"
        "custom/voxtype"
        "custom/screenrecording-indicator"
        "custom/idle-indicator"
        "custom/notification-silencing-indicator"
      ];
      modules-right = [
        "group/tray-expander"
        "bluetooth"
        "network"
        "pulseaudio"
        "cpu"
        "battery"
      ];

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          default = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "0";
          active = "󱓻";
        };
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };

      "custom/leenix" = {
        format = "󱄅";
        on-click = "leenix-menu";
        on-click-right = "xdg-terminal-exec";
        tooltip-format = "Leenix Menu\n\nSuper + Alt + Space";
      };

      "custom/weather" = {
        exec = lib.getExe scripts.weather;
        return-type = "json";
        interval = 60;
        tooltip = true;
        on-click = ''notify-send -u low "$(leenix-weather-status)"'';
      };

      "cpu" = {
        interval = 5;
        format = "󰍛";
        on-click = "leenix-launch-or-focus-tui btop";
        on-click-right = "xdg-terminal-exec";
      };

      "clock" = {
        format = "{:L%A %H:%M}";
        format-alt = "{:L%d %B W%V %Y}";
        tooltip = false;
        on-click-right = "leenix-launch-floating-terminal-with-presentation leenix-tz-select";
      };

      "network" = {
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰤮";
        tooltip-format-wifi = "{essid} ({frequency} GHz)";
        tooltip-format-ethernet = "Connected";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        spacing = 1;
        on-click = "leenix-launch-wifi";
      };

      "battery" = {
        format = "{capacity}% {icon}";
        format-discharging = "{icon}";
        format-charging = "{icon}";
        format-plugged = "";
        format-icons = {
          charging = [
            "󰢜"
            "󰂆"
            "󰂇"
            "󰂈"
            "󰢝"
            "󰂉"
            "󰢞"
            "󰂊"
            "󰂋"
            "󰂅"
          ];
          default = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        format-full = "󰂅";
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        interval = 5;
        on-click = "leenix-menu power";
        on-click-right = ''notify-send -u low "$(leenix-battery-status)"'';
        states = {
          warning = 20;
          critical = 10;
        };
      };

      "bluetooth" = {
        format = "";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        format-no-controller = "";
        tooltip-format = "Devices connected: {num_connections}";
        on-click = "leenix-launch-bluetooth";
      };

      "pulseaudio" = {
        format = "{icon}";
        on-click = "leenix-launch-audio";
        on-click-right = "pamixer -t";
        tooltip-format = "Playing at {volume}%";
        scroll-step = 5;
        format-muted = "";
        format-icons = {
          headphone = "";
          headset = "";
          default = [
            ""
            ""
            ""
          ];
        };
      };

      "group/tray-expander" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 600;
          children-class = "tray-group-item";
        };
        modules = [ "custom/expand-icon" "tray" ];
      };

      "custom/expand-icon" = {
        format = "";
        tooltip = false;
        on-scroll-up = "";
        on-scroll-down = "";
        on-scroll-left = "";
        on-scroll-right = "";
      };

      "custom/screenrecording-indicator" = {
        on-click = "leenix-capture-screenrecording";
        exec = lib.getExe scripts.screenrecordingIndicator;
        signal = 8;
        return-type = "json";
      };

      "custom/idle-indicator" = {
        on-click = "leenix-toggle-idle";
        exec = lib.getExe scripts.idleIndicator;
        signal = 9;
        return-type = "json";
      };

      "custom/notification-silencing-indicator" = {
        on-click = "leenix-toggle-notification-silencing";
        exec = lib.getExe scripts.notificationIndicator;
        signal = 10;
        return-type = "json";
      };

      "custom/voxtype" = {
        exec = "leenix-voxtype-status";
        return-type = "json";
        format = "{icon}";
        format-icons = {
          idle = "";
          recording = "󰍬";
          transcribing = "󰔟";
        };
        tooltip = true;
        on-click-right = "leenix-voxtype-config";
        on-click = "leenix-voxtype-model";
      };

      "tray" = {
        icon-size = 12;
        spacing = 17;
      };
    };
  };
}
