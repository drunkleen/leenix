{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-touchpad";

      runtimeInputs = with pkgs; [
        coreutils
        hyprland
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Enable, disable, or toggle the touchpad

        # leenix:args=[on|off|toggle|status]

        STATE_CONF="$HOME/.local/state/leenix/toggles/hypr/touchpad-disabled.conf"

        # Hyprland 0.56 uses the Lua config API; the legacy `hyprctl keyword
        # device[...]` parser is gone ("keyword can't work with non-legacy
        # parsers"). Runtime device control is `hyprctl eval` with the hl.device
        # config function.
        device="$(leenix-hw-touchpad)"

        if [[ -z $device ]]; then
          echo "No touchpad device found" >&2
          exit 1
        fi

        osd() {
          local icon="$1"
          local message="$2"
          if command -v leenix-swayosd-client >/dev/null 2>&1; then
            leenix-swayosd-client --custom-icon "$icon" --custom-message "$message" 2>/dev/null ||
              notify-send -u low "''${message}" 2>/dev/null
          else
            notify-send -u low "''${message}" 2>/dev/null
          fi
        }

        is_disabled() {
          [[ -f $STATE_CONF ]]
        }

        enable() {
          hyprctl eval "hl.device({ name = \"$device\", enabled = true })" >/dev/null
          rm -f "$STATE_CONF"
          osd input-touchpad-symbolic "Touchpad enabled"
        }

        disable() {
          hyprctl eval "hl.device({ name = \"$device\", enabled = false })" >/dev/null
          mkdir -p "$(dirname "$STATE_CONF")"
          printf 'hl.device({ name = "%s", enabled = false })\n' "$device" > "$STATE_CONF"
          osd touchpad-disabled-symbolic "Touchpad disabled"
        }

        case "''${1:-toggle}" in
          on)
            enable
            ;;
          off)
            disable
            ;;
          status)
            if is_disabled; then
              echo disabled
            else
              echo enabled
            fi
            ;;
          toggle)
            if is_disabled; then
              enable
            else
              disable
            fi
            ;;
        esac
      '';
    })
  ];
}
