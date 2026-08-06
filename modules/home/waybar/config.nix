{
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      spacing = 8;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "tray"
        "network"
        "bluetooth"
        "power-profiles-daemon"
        "wireplumber"
        "battery"
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";

        format-icons = {
          active = "";
          default = "";
          urgent = "";
        };
      };

      "hyprland/window" = {
        format = "{}";
        max-length = 45;
        separate-outputs = true;
      };

      clock = {
        format = "  {:%H:%M}";
        format-alt = "  {:%A, %d %B %Y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈀  Connected";
        format-disconnected = "󰖪  Offline";
        tooltip-format = "{ifname}\n{ipaddr}/{cidr}\nSignal: {signalStrength}%";
      };

      bluetooth = {
        format = "  {status}";
        format-connected = "  {num_connections}";
        format-disabled = "󰂲";
        tooltip-format = "{controller_alias}\n{num_connections} connected";
      };

      power-profiles-daemon = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}";

        format-icons = {
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };

      wireplumber = {
        format = "{icon}  {volume}%";
        format-muted = "󰝟  Muted";

        format-icons = [
          ""
          ""
          ""
        ];

        on-click = "pwvucontrol";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };

        format = "{icon}  {capacity}%";
        format-charging = "󰂄  {capacity}%";
        format-plugged = "  {capacity}%";

        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      tray = {
        spacing = 10;
      };
    };
  };
}