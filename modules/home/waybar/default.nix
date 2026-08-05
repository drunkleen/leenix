{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      targets = [
        "graphical-session.target"
      ];
    };

    settings = {
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

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(17, 18, 32, 0.92);
        color: #cdd6f4;
      }

      #workspaces {
        margin: 5px 0 5px 8px;
        padding: 0 6px;
        background: rgba(30, 30, 46, 0.92);
        border-radius: 10px;
      }

      #workspaces button {
        padding: 0 7px;
        color: #6c7086;
        background: transparent;
      }

      #workspaces button.active {
        color: #a6e3a1;
      }

      #workspaces button.urgent {
        color: #f38ba8;
      }

      #window {
        margin-left: 8px;
        color: #bac2de;
      }

      #clock,
      #network,
      #bluetooth,
      #power-profiles-daemon,
      #wireplumber,
      #battery,
      #tray {
        margin: 5px 4px;
        padding: 0 10px;
        background: rgba(30, 30, 46, 0.92);
        border-radius: 10px;
      }

      #clock {
        color: #cba6f7;
      }

      #network {
        color: #f9e2af;
      }

      #bluetooth {
        color: #89b4fa;
      }

      #power-profiles-daemon {
        color: #fab387;
      }

      #wireplumber {
        color: #94e2d5;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }
    '';
  };

  home.packages = with pkgs; [
    pwvucontrol
  ];
}
