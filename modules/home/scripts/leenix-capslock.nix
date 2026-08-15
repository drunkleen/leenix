{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-capslock";

      runtimeInputs = with pkgs; [
        coreutils
        wtype
        hyprland
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle Caps Lock via Wayland virtual keyboard (wtype)

        # leenix:args=<on|off|toggle|status>

        # Where the kernel exposes a Caps Lock LED, it is the authoritative state
        # source and `on`/`off` are absolute. Without an LED the effective state
        # is unknowable from userspace, so a bare press (toggle) is the fallback.

        led_state() {
          local f
          for f in /sys/class/leds/*capslock*/brightness; do
            [[ -e $f ]] && { cat "$f"; return 0; }
          done
          echo unknown
        }

        cmd_on() {
          local s
          s=$(led_state)
          if [[ $s != "1" ]]; then
            wtype -k Caps_Lock 2>/dev/null
          fi
        }

        cmd_off() {
          local s
          s=$(led_state)
          if [[ $s == "1" ]]; then
            wtype -k Caps_Lock 2>/dev/null
          fi
        }

        cmd_status() {
          local s
          s=$(led_state)
          if [[ $s == "1" ]]; then echo "on"; elif [[ $s == "0" ]]; then echo "off"; else echo "unknown"; fi
        }

        case "''${1:-toggle}" in
          on) cmd_on ;;
          off) cmd_off ;;
          toggle) wtype -k Caps_Lock 2>/dev/null ;;
          status) cmd_status ;;
          *)
            echo "Usage: leenix-capslock <on|off|toggle|status>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
