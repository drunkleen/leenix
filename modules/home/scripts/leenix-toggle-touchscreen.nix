{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-touchscreen";

      runtimeInputs = with pkgs; [
        coreutils
        hyprland
        jq
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Enable, disable, toggle, or show status of the touchscreen

        # leenix:args=[on|off|toggle|status] [--no-osd]

        STATE_CONF="$HOME/.local/state/leenix/toggles/hypr/touchscreen-disabled.conf"

        NO_OSD=false
        [[ ''${1:-} == "--no-osd" ]] && { NO_OSD=true; shift; }

        # Touchscreens are reported by Hyprland under .touch and .tablets.
        # Group siblings by the device prefix, mirroring the touchpad logic.
        anchor="$(leenix-hw-touchscreen)"

        if [[ -z $anchor ]]; then
          echo "No touchscreen device found" >&2
          exit 1
        fi

        prefix="''${anchor%-*}"
        mapfile -t devices < <(hyprctl devices -j | jq -r --arg p "$prefix" '[.touch[]?.name, .tablets[]?.name] | map(select(startswith($p))) | .[]')
        [[ ''${#devices[@]} -eq 0 ]] && devices=("$anchor")

        apply() {
          local state="$1"
          local failed=0
          for dev in "''${devices[@]}"; do
            local out
            out=$(hyprctl eval "hl.device({ name = \"$dev\", enabled = $state })" 2>/dev/null)
            [[ $out == error* ]] && failed=1
          done
          return $failed
        }

        osd() {
          local icon="$1"
          local message="$2"
          if [[ $NO_OSD == true ]]; then
            return 0
          fi
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
          if ! apply true; then
            notify-send -u critical "Touchscreen enable failed" "Hyprland rejected the device change" 2>/dev/null
            return 1
          fi
          rm -f "$STATE_CONF"
          osd leenix-touchscreen-on-symbolic "Touchscreen enabled"
        }

        disable() {
          if ! apply false; then
            notify-send -u critical "Touchscreen disable failed" "Hyprland rejected the device change" 2>/dev/null
            return 1
          fi
          mkdir -p "$(dirname "$STATE_CONF")"
          : > "$STATE_CONF"
          osd leenix-touchscreen-off-symbolic "Touchscreen disabled"
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
              echo "desired: disabled"
            else
              echo "desired: enabled"
            fi
            echo "effective: unknown"
            ;;
          toggle)
            if is_disabled; then
              enable
            else
              disable
            fi
            ;;
          *)
            echo "Usage: leenix-toggle-touchscreen <on|off|toggle|status> [--no-osd]" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
