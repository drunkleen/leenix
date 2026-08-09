{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-monitor-internal-mirror";

      runtimeInputs = with pkgs; [
        hyprland
        jq
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Enable, disable, toggle, or recover mirroring the internal display to an external monitor

        # leenix:args=<on|off|toggle|recover>

        TOGGLE="internal-monitor-mirror"
        TOGGLE_FLAG="$HOME/.local/state/leenix/toggles/hypr/$TOGGLE.conf"
        DISABLE_TOGGLE="internal-monitor-disable"

        # Get names dynamically

        INTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.name | contains("eDP")).name' | head -n 1)

        # Get the first available external monitor

        EXTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.name | contains("eDP") | not).name' | head -n 1)

        enable() {
          if [[ -z "$EXTERNAL" ]]; then
            notify-send -u low "󰍹    No external monitors found for mirror"
            exit 1
          fi

          if [[ -z "$INTERNAL" ]]; then
            notify-send -u low "󰍹    No laptop monitor found to mirror"
            exit 1
          fi

          if leenix-hyprland-toggle-enabled "$DISABLE_TOGGLE"; then
            leenix-hyprland-toggle "$DISABLE_TOGGLE"
          fi

          if leenix-hyprland-toggle-disabled "$TOGGLE"; then
            echo "monitor=$EXTERNAL, preferred, auto, 1, mirror, $INTERNAL" > "$TOGGLE_FLAG"
            notify-send -u low "󰍹    Mirroring enabled ($EXTERNAL)"
            hyprctl reload
          fi
        }

        disable() {
          if leenix-hyprland-toggle-enabled "$TOGGLE"; then
            leenix-hyprland-toggle --disabled-notification "󰍹    Extended mode restored" "$TOGGLE"
          fi
        }

        recover() {
          if ! leenix-hw-external-monitors && leenix-hyprland-toggle-enabled "$TOGGLE"; then
            leenix-hyprland-toggle "$TOGGLE"
          fi
        }

        case "''${1:-}" in
          on) enable ;;
          off) disable ;;
          toggle) if leenix-hyprland-toggle-enabled "$TOGGLE"; then disable; else enable; fi ;;
          recover) recover ;;
          *)
            echo "Usage: $(basename "$0") {on|off|toggle|recover}" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}