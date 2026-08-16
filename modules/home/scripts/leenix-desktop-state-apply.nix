{
  lib,
  pkgs,
  ...
}:

let
  applyCmd = pkgs.writeShellApplication {
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

      # Waybar visibility: desired state resolved by leenix-waybar-state.
      # This oneshot is the sole login/session authority deciding whether the
      # supervisor-only waybar.service starts (persisted OFF stays off).
      if command -v leenix-toggle-waybar >/dev/null 2>&1; then
        leenix-toggle-waybar apply
      fi

      # 1-window square ratio persists across login.
      if command -v leenix-hyprland-window-single-square-aspect-toggle >/dev/null 2>&1; then
        leenix-hyprland-window-single-square-aspect-toggle apply
      fi

      # Automatic lock (hypridle): desired-disabled must survive relogin.
      if command -v leenix-toggle-idle >/dev/null 2>&1; then
        leenix-toggle-idle apply
      fi

      if command -v leenix-toggle-touchpad >/dev/null 2>&1; then
        if [[ -f "$HOME/.local/state/leenix/toggles/hypr/touchpad-disabled.conf" ]]; then
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
        if [[ -n $kbd && -f "$HOME/.local/state/leenix/hardware/keyboard-backlight.leenix" ]]; then
          want=$(cat "$HOME/.local/state/leenix/hardware/keyboard-backlight.leenix" 2>/dev/null || echo 0)
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
  };
in
{
  home.packages = [ applyCmd ];

  # Canonical session-start restoration: a oneshot bound to the UWSM graphical
  # session. This is the SOLE authority that decides whether waybar.service
  # starts (persisted desired visibility). It runs once, after the graphical
  # session is up — no Hyprland exec-once, no sleeps, no polling.
  systemd.user.services.leenix-desktop-state-apply = {
    Unit = {
      Description = "LEENIX reapply persistent desktop states";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe applyCmd}";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
