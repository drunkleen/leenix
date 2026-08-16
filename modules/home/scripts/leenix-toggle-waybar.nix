{
  pkgs,
  ...
}:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-waybar";

      runtimeInputs = with pkgs; [
        systemd
        gnused
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle Waybar visibility

        # leenix:args=[on|off|toggle|apply|status]

        # Waybar is a supervisor-only systemd user service. The desired
        # visibility is persisted via leenix-state (toggles/waybar) and the
        # process is controlled via systemctl --user — never pgrep/pkill.
        # Desired state is resolved by leenix-waybar-state (canonical helper).
        # Persisted desired state is written BEFORE the process action so a
        # failed start/stop never loses the user's requested preference.

        desired_state() {
          leenix-waybar-state | sed -n 's/^desired: //p'
        }

        on() {
          leenix-state set toggles/waybar enabled
          systemctl --user start waybar.service
          notify-send -u low "󰍜    Waybar enabled"
        }

        off() {
          leenix-state set toggles/waybar disabled
          systemctl --user stop waybar.service
          notify-send -u low "󰍜    Waybar disabled"
        }

        apply() {
          case "$(desired_state)" in
            enabled) systemctl --user start waybar.service ;;
            disabled) systemctl --user stop waybar.service ;;
          esac
        }

        case "''${1:-toggle}" in
          on) on ;;
          off) off ;;
          toggle)
            case "$(desired_state)" in
              enabled) off ;;
              disabled) on ;;
            esac
            ;;
          apply) apply ;;
          status) leenix-waybar-state ;;
          *)
            echo "Usage: leenix-toggle-waybar <on|off|toggle|apply|status>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
