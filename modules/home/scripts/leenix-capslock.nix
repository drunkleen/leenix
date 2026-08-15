{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-capslock";
      excludeShellChecks = [ "SC2086" "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
        python3
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle Caps Lock (kernel evdev injection)

        # leenix:args=<on|off|toggle|status>

        # Injects a synthetic KEY_CAPSLOCK press/release into a keyboard evdev
        # device. wtype's virtual-keyboard path does not deliver on all
        # compositors (Hyprland 0.56 + wtype 0.4 in particular), but a kernel
        # evdev injection is processed exactly like a real keypress: the
        # compositor toggles the global XKB caps state and syncs the keyboard
        # LEDs. The user only needs read/write access to the input device
        # (the `input` group on NixOS) — no pkexec required.
        #
        # State source: the kernel capslock LEDs (any keyboard reporting ON
        # means caps is on). Portable: on a machine without capslock LEDs the
        # state is "unknown" and on/off fall back to a best-effort toggle.

        led_state() {
          local any=0 seen=0 f
          for f in /sys/class/leds/*capslock*/brightness; do
            [[ -e $f ]] || continue
            seen=1
            if [[ $(cat "$f") == "1" ]]; then any=1; fi
          done
          if [[ $seen -eq 0 ]]; then
            echo unknown
          elif [[ $any -eq 1 ]]; then
            echo on
          else
            echo off
          fi
        }

        # First keyboard evdev device (name-based, portable across machines).
        keyboard_event() {
          local d name e
          for d in /sys/class/input/input*; do
            name=$(cat "$d/name" 2>/dev/null)
            case "$name" in
              *[Kk]eyboard*|AT\ Translated*|*kbd*)
                for e in "$d"/event*; do
                  [[ -e "$e" ]] && { echo "/dev/input/$(basename "$e")"; return 0; }
                done
                ;;
            esac
          done
          return 1
        }

        press_caps() {
          local dev
          dev=$(keyboard_event) || return 1
          python3 - "$dev" <<'PY'
import struct, time, sys
dev = sys.argv[1]
def ev(typ, code, value):
    t = time.time()
    s, u = int(t), int((t % 1) * 1_000_000)
    return struct.pack("llHHI", s, u, typ, code, value)
EV_KEY, EV_SYN = 1, 0
KEY_CAPSLOCK, SYN_REPORT = 58, 0
buf = b"".join([
    ev(EV_KEY, KEY_CAPSLOCK, 1), ev(EV_SYN, SYN_REPORT, 0),
    ev(EV_KEY, KEY_CAPSLOCK, 0), ev(EV_SYN, SYN_REPORT, 0),
])
with open(dev, "wb", buffering=0) as f:
    f.write(buf)
PY
        }

        cmd_on() {
          local s
          s=$(led_state)
          if [[ $s != "on" ]]; then
            if ! press_caps; then
              notify-send -u critical "Caps Lock enable failed" "No keyboard input device found." 2>/dev/null
              return 1
            fi
            sleep 0.2
            s=$(led_state)
            if [[ $s != "on" && $s != "unknown" ]]; then
              notify-send -u critical "Caps Lock enable failed" "Caps Lock state did not change after toggling." 2>/dev/null
              return 1
            fi
          fi
        }

        cmd_off() {
          local s
          s=$(led_state)
          if [[ $s == "on" ]]; then
            if ! press_caps; then
              notify-send -u critical "Caps Lock disable failed" "No keyboard input device found." 2>/dev/null
              return 1
            fi
            sleep 0.2
            s=$(led_state)
            if [[ $s == "on" ]]; then
              notify-send -u critical "Caps Lock disable failed" "Caps Lock state did not change after toggling." 2>/dev/null
              return 1
            fi
          fi
        }

        cmd_toggle() {
          press_caps || {
            notify-send -u critical "Caps Lock toggle failed" "No keyboard input device found." 2>/dev/null
            return 1
          }
        }

        case "''${1:-toggle}" in
          on) cmd_on ;;
          off) cmd_off ;;
          toggle) cmd_toggle ;;
          status) led_state ;;
          *)
            echo "Usage: leenix-capslock <on|off|toggle|status>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
