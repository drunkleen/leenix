{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-monitor-internal-mirror";
      excludeShellChecks = [ "SC2086" ];

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

        # Mirroring is a monitor runtime property owned by HyprMon's hyprmon.lua
        # (mirror = "<source>"). Persistent changes go through the single
        # canonical locked writer `leenix-hyprmon-edit`; live application uses
        # the Hyprland Lua API immediately, so the mirror survives logout/login.

        internal_monitor() {
          hyprctl monitors all -j 2>/dev/null | jq -r '.[] | select(.name | test("^(eDP|LVDS|DSI)-")) | .name' | head -1
        }

        external_monitor() {
          hyprctl monitors all -j 2>/dev/null | jq -r --arg i "$1" '.[] | select(.name != $i and .name != "FALLBACK") | .name' | head -1
        }

        # Persist `mirror = <source>` on the target monitor rule in hyprmon.lua
        # via the single canonical locked writer (leenix-hyprmon-edit).
        persist_mirror() {
          leenix-hyprmon-edit mirror "$1" "$2"
        }

        # Remove any mirror on the target monitor (restore extended mode).
        persist_unmirror() {
          leenix-hyprmon-edit unmirror "$1"
        }

        enable() {
          local internal external
          internal=$(internal_monitor)
          external=$(external_monitor "$internal")
          if [[ -z $external ]]; then
            notify-send -u low "󰍹    No external monitors found for mirror"
            exit 1
          fi
          if [[ -z $internal ]]; then
            notify-send -u low "󰍹    No laptop monitor found to mirror"
            exit 1
          fi
          persist_mirror "$external" "$internal"
          hyprctl eval "hl.monitor({ output = \"$external\", disabled = false, mirror = \"$internal\" })" >/dev/null 2>&1
          notify-send -u low "󰍹    Mirroring enabled ($external ← $internal)"
        }

        disable() {
          local internal external
          internal=$(internal_monitor)
          external=$(external_monitor "$internal")
          [[ -n $external ]] || exit 0
          persist_unmirror "$external"
          hyprctl eval "hl.monitor({ output = \"$external\", disabled = false })" >/dev/null 2>&1
          notify-send -u low "󰍹    Extended mode restored"
        }

        mirror_enabled() {
          local external
          external=$(external_monitor "$(internal_monitor)")
          [[ -n $external ]] || return 1
          hyprctl monitors all -j 2>/dev/null | jq -e --arg n "$external" '.[] | select(.name == $n) | .mirror != ""' >/dev/null 2>&1
        }

        recover() {
          # If the external display disappeared, ensure mirroring is dropped so
          # the next reconnect starts in extended mode.
          local external
          external=$(external_monitor "$(internal_monitor)")
          if [[ -z $external ]] && ! command -v leenix-hw-external-monitors >/dev/null 2>&1; then
            : # no external known; nothing to recover
          fi
          if mirror_enabled && [[ -z $external ]]; then
            disable
          fi
        }

        case "''${1:-}" in
          on) enable ;;
          off) disable ;;
          toggle) if mirror_enabled; then disable; else enable; fi ;;
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
