{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-desktop-state-apply";

      runtimeInputs = with pkgs; [
        coreutils
        brightnessctl
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reapply persistent desired desktop/hyprland states at graphical-session start

        # leenix:hidden=true

        # Applies only capabilities whose scripts are installed on this host.
        # Each is self-gating; Nix remains the source of declarative config.

        set -uo pipefail

        # 1-window square ratio persists across login.
        if command -v leenix-hyprland-window-single-square-aspect-toggle >/dev/null 2>&1; then
          leenix-hyprland-window-single-square-aspect-toggle apply
        fi

        # Automatic lock (hypridle): desired-disabled must survive relogin.
        if command -v leenix-toggle-idle >/dev/null 2>&1; then
          leenix-toggle-idle apply
        fi

        if command -v leenix-toggle-touchpad >/dev/null 2>&1; then
          if [[ -f "''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/toggles/hypr/touchpad-disabled.conf" ]]; then
            leenix-toggle-touchpad off --no-osd
          fi
        fi

        # Keyboard backlight: restore the user's last chosen level if a device
        # exists and a desired level was persisted (ASUS firmware controls boot
        # state, so this only overrides when the user explicitly set one).
        if command -v brightnessctl >/dev/null 2>&1; then
          kbd=""
          for f in /sys/class/leds/*kbd_backlight*/brightness; do
            [[ -e $f ]] && { kbd=$f; break; }
          done
          if [[ -n $kbd && -f "''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/hardware/keyboard-backlight.leenix" ]]; then
            want=$(cat "''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/hardware/keyboard-backlight.leenix" 2>/dev/null || echo 0)
            max=$(cat "''${kbd%/brightness}/max_brightness" 2>/dev/null || echo 1)
            (( want < 0 )) && want=0
            (( want > max )) && want=$max
            brightnessctl -d "$(basename "$(dirname "$kbd")")" set "$want" >/dev/null 2>&1 || true
          fi
        fi

        # Monitor reconciliation (internal-panel safety + HyprMon desired
        # topology). The leenix-monitor-state-watch service also reconciles on
        # hotplug; applying at session start covers the boot/login case.
        if command -v leenix-monitor >/dev/null 2>&1; then
          leenix-monitor reconcile >/dev/null 2>&1 || true
        fi
      '';
    })
  ];
}
