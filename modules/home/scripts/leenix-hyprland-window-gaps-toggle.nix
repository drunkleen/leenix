{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-window-gaps-toggle";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        hyprland
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle window gaps globally between no gaps and the default

        # leenix:args=[on|off|toggle|status]

        # Runtime control via the Hyprland Lua API. Desired state persists in
        # XDG state; effective state is read back from Hyprland itself.

        STATE="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/toggles/window-gaps.leenix"

        GAPS_IN_DEFAULT=5
        GAPS_OUT_DEFAULT=10

        desired() {
          [[ -f $STATE && $(cat "$STATE") == "disabled" ]] && echo disabled || echo enabled
        }

        effective() {
          local gi
          gi=$(hyprctl getoption general:gaps_in 2>/dev/null | sed -n 's/.*: *\([0-9]*\).*/\1/p' | head -1)
          if [[ -z $gi || $gi != "0" ]]; then echo enabled; else echo disabled; fi
        }

        apply() {
          local state="$1"
          if [[ $state == "disabled" ]]; then
            hyprctl eval "hl.config({ general = { gaps_in = 0, gaps_out = 0 } })" >/dev/null 2>&1
          else
            hyprctl eval "hl.config({ general = { gaps_in = $GAPS_IN_DEFAULT, gaps_out = $GAPS_OUT_DEFAULT } })" >/dev/null 2>&1
          fi
        }

        case "''${1:-toggle}" in
          on)
            leenix-state clear toggles/window-gaps 2>/dev/null || true
            apply enabled
            notify-send -u low "    Window gaps enabled" 2>/dev/null
            ;;
          off)
            leenix-state set toggles/window-gaps disabled 2>/dev/null || true
            apply disabled
            notify-send -u low "    Window gaps disabled" 2>/dev/null
            ;;
          toggle)
            if [[ $(desired) == "disabled" ]]; then
              leenix-state clear toggles/window-gaps 2>/dev/null || true
              apply enabled
              notify-send -u low "    Window gaps enabled" 2>/dev/null
            else
              leenix-state set toggles/window-gaps disabled 2>/dev/null || true
              apply disabled
              notify-send -u low "    Window gaps disabled" 2>/dev/null
            fi
            ;;
          status)
            echo "desired: $(desired)"
            echo "effective: $(effective)"
            ;;
          *)
            echo "Usage: leenix-hyprland-window-gaps-toggle <on|off|toggle|status>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
