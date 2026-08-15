{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-window-single-square-aspect-toggle";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        hyprland
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle the single-window square aspect ratio

        # leenix:args=[on|off|toggle|status]

        # Uses Hyprland's native `layout.single_window_aspect_ratio` (Lua API),
        # which constrains the tiling of a workspace that holds exactly one
        # window. 1:1 square when enabled, {0,0} (off) when disabled. Desired
        # state persists under XDG state and is reapplied at session start.

        STATE="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/toggles/1window-ratio.leenix"

        desired() {
          [[ -f $STATE ]] && echo enabled || echo disabled
        }

        effective() {
          local v
          v=$(hyprctl getoption layout:single_window_aspect_ratio 2>/dev/null | sed -n 's/.*vec2: \[\([0-9]*\), *\([0-9]*\)\].*/\1 \2/p' | head -1)
          if [[ $v == "1 1" ]]; then echo enabled; else echo disabled; fi
        }

        apply() {
          if [[ $1 == "on" ]]; then
            hyprctl eval 'hl.config({ layout = { single_window_aspect_ratio = { 1, 1 } } })' >/dev/null 2>&1
          else
            hyprctl eval 'hl.config({ layout = { single_window_aspect_ratio = { 0, 0 } } })' >/dev/null 2>&1
          fi
        }

        enable() {
          leenix-state set toggles/1window-ratio enabled 2>/dev/null || true
          apply on
          notify-send -u low "󰄖    Single-window square ratio enabled" 2>/dev/null
        }

        disable() {
          leenix-state clear toggles/1window-ratio 2>/dev/null || true
          apply off
          notify-send -u low "󰄖    Single-window square ratio disabled" 2>/dev/null
        }

        case "''${1:-toggle}" in
          on) enable ;;
          off) disable ;;
          toggle) if [[ $(desired) == "enabled" ]]; then disable; else enable; fi ;;
          status)
            echo "desired: $(desired)"
            echo "effective: $(effective)"
            ;;
          apply)
            if [[ $(desired) == "enabled" ]]; then apply on; else apply off; fi
            ;;
          *)
            echo "Usage: leenix-hyprland-window-single-square-aspect-toggle <on|off|toggle|status|apply>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
