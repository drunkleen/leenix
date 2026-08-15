{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-airplane";

      runtimeInputs = with pkgs; [
        coreutils
        jq
        iwd
        bluez
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Composite airplane mode: disable/restore Wi-Fi + Bluetooth

        # leenix:args=<status|on|off>

        # Desired composite state is persisted as JSON under the state root so
        # the previous radio state can be restored on OFF. Real radio state is
        # queried from iwd (iwctl) and bluetoothd (bluetoothctl).

        set -uo pipefail

        STATE="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/network/airplane-mode.leenix"

        wifi_enabled() {
          iwctl device list 2>/dev/null | grep -qE '^\s+[a-z0-9]+.*Powered on' && return 0 || return 1
        }

        bt_enabled() {
          bluetoothctl show 2>/dev/null | grep -qE 'Powered: yes' && return 0 || return 1
        }

        status() {
          local air="off"
          [[ -f $STATE ]] && air=$(jq -r '.enabled' "$STATE" 2>/dev/null)
          echo "airplane: $air"
          if wifi_enabled; then echo "wifi: on"; else echo "wifi: off"; fi
          if bt_enabled; then echo "bluetooth: on"; else echo "bluetooth: off"; fi
        }

        save_previous() {
          local w="false" b="false"
          mkdir -p "$(dirname "$STATE")"
          wifi_enabled && w="true"
          bt_enabled && b="true"
          printf '{"enabled": true, "wifiPreviouslyEnabled": %s, "bluetoothPreviouslyEnabled": %s}\n' "$w" "$b" > "$STATE.tmp"
          mv -f "$STATE.tmp" "$STATE"
        }

        on() {
          save_previous
          if wifi_enabled; then
            for dev in $(iwctl device list 2>/dev/null | awk 'NR>4 && $1 ~ /^[a-z0-9]+$/ {print $1}'); do
              iwctl device "$dev" set-property Powered off 2>/dev/null || true
            done
          fi
          if bt_enabled; then
            bluetoothctl power off 2>/dev/null || true
          fi
          echo "Airplane mode ON"
        }

        off() {
          local w="true" b="false"
          if [[ -f $STATE ]]; then
            w=$(jq -r '.wifiPreviouslyEnabled // true' "$STATE" 2>/dev/null)
            b=$(jq -r '.bluetoothPreviouslyEnabled // false' "$STATE" 2>/dev/null)
          fi
          if [[ $w == "true" ]] && ! wifi_enabled; then
            for dev in $(iwctl device list 2>/dev/null | awk 'NR>4 && $1 ~ /^[a-z0-9]+$/ {print $1}'); do
              iwctl device "$dev" set-property Powered on 2>/dev/null || true
            done
          fi
          if [[ $b == "true" ]] && ! bt_enabled; then
            bluetoothctl power on 2>/dev/null || true
          fi
          rm -f "$STATE"
          echo "Airplane mode OFF"
        }

        case "''${1:-status}" in
          status) status ;;
          on) on ;;
          off) off ;;
          *) echo "Usage: leenix-airplane <status|on|off>" >&2; exit 1 ;;
        esac
      '';
    })
  ];
}
