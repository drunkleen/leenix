{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-touchpad";

      runtimeInputs = with pkgs; [
        coreutils
        hyprland
        jq
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Enable, disable, toggle, or show status of the touchpad

        # leenix:args=[on|off|toggle|status] [--no-osd]

        STATE_CONF="$HOME/.local/state/leenix/toggles/hypr/touchpad-disabled.conf"

        NO_OSD=false
        # Guard against nounset: the XF86TouchpadToggle binding calls this with
        # NO arguments, so $1 may be unset.
        [[ ''${1:-} == "--no-osd" ]] && { NO_OSD=true; shift; }

        # Discover the touchpad anchor device. Many HID touchpads expose TWO
        # Hyprland pointer devices with the same base name: a "-mouse" sibling
        # that carries the relative pointer motion (REL capability) and a
        # "-touchpad" sibling that carries the absolute multitouch data.
        # Disabling only the "-touchpad" device leaves the "-mouse" sibling
        # active, so the cursor keeps moving. We must disable ALL siblings
        # sharing the device prefix.
        anchor="$(leenix-hw-touchpad)"

        if [[ -z $anchor ]]; then
          echo "No touchpad device found" >&2
          exit 1
        fi

        prefix="''${anchor%-*}"
        mapfile -t devices < <(hyprctl devices -j | jq -r --arg p "$prefix" '[.mice[] | .name | select(startswith($p))] | .[]')
        [[ ''${#devices[@]} -eq 0 ]] && devices=("$anchor")

        # Runtime control via the Hyprland 0.56 Lua API. `hl.device` registers
        # the device config and schedules an input-device refresh; on success
        # the pointer is detached and libinput send-events is disabled.
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
            notify-send -u critical "Touchpad enable failed" "Hyprland rejected the device change" 2>/dev/null
            return 1
          fi
          rm -f "$STATE_CONF"
          osd leenix-touchpad-on-symbolic "Touchpad enabled"
        }

        disable() {
          if ! apply false; then
            notify-send -u critical "Touchpad disable failed" "Hyprland rejected the device change" 2>/dev/null
            return 1
          fi
          mkdir -p "$(dirname "$STATE_CONF")"
          : > "$STATE_CONF"
          osd leenix-touchpad-off-symbolic "Touchpad disabled"
        }

        case "''${1:-toggle}" in
          on)
            enable
            ;;
          off)
            disable
            ;;
          status)
            # Hyprland 0.56 does not expose a readable effective per-device
            # enabled state (devices -j omits it; there is no getoption). We
            # report DESIRED state plus honest effective=unknown. Applying the
            # desired state has been verified to reliably detach the device.
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
            echo "Usage: leenix-toggle-touchpad <on|off|toggle|status> [--no-osd]" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
