{
  programs.waybar.settings = {
    mainBar = {
      reload_style_on_change = true;

      layer = "top";
      position = "top";
      height = 26;
      spacing = 0;

      modules-left = [
        "custom/leenium"
        "hyprland/workspaces"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "group/tray-expander"
        "bluetooth"
        "network"
        "wireplumber"
        "cpu"
        "battery"
      ];

      "custom/leenium" = {
        format = "󱄅";
        tooltip-format = "Leenium Menu";
        on-click-right = "uwsm app -- kitty";
      };

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

        # مثل Omarchy فقط workspaceهای ۱ تا ۵ همیشه دیده می‌شوند.
        # workspaceهای بالاتر فقط زمانی ظاهر می‌شوند که وجود داشته باشند.
        persistent-workspaces = {
          "1" = [ ];
          "2" = [ ];
          "3" = [ ];
          "4" = [ ];
          "5" = [ ];
        };
      };

      clock = {
        format = "{:%A %H:%M}";
        format-alt = "{:%d %B W%V %Y}";
        tooltip = false;
      };

      network = {
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
      };

      bluetooth = {
        format = "";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        format-no-controller = "";
        tooltip-format = "Devices connected: {num_connections}";
      };

      wireplumber = {
        format = "{icon}";
        format-muted = "";

        format-icons = [
          ""
          ""
          ""
        ];

        tooltip-format = "Playing at {volume}%";
        scroll-step = 5;

        on-click = "pwvucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      cpu = {
        interval = 5;
        format = "󰍛";
        tooltip-format = "CPU usage: {usage}%";

        on-click = "uwsm app -- kitty -e btop";
        on-click-right = "uwsm app -- kitty";
      };

      battery = {
        format = "{capacity}% {icon}";
        format-discharging = "{icon}";
        format-charging = "{icon}";
        format-plugged = "";
        format-full = "󰂅";

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

        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";

        interval = 5;

        states = {
          warning = 20;
          critical = 10;
        };
      };

      "group/tray-expander" = {
        orientation = "inherit";

        drawer = {
          transition-duration = 600;
          children-class = "tray-group-item";
        };

        modules = [
          "custom/expand-icon"
          "tray"
        ];
      };

      "custom/expand-icon" = {
        format = "";
        tooltip = false;

        on-scroll-up = "";
        on-scroll-down = "";
        on-scroll-left = "";
        on-scroll-right = "";
      };

      tray = {
        icon-size = 12;
        spacing = 17;
      };
    };
  };
}