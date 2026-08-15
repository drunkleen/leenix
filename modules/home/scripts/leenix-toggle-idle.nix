{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-idle";

      runtimeInputs = with pkgs; [
        systemd
        libnotify
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle hypridle idle locking (automatic lock)

        # leenix:args=[on|off|toggle|apply]

        # hypridle runs as a canonical user service (hypridle.service, wanted by
        # graphical-session.target), so runtime control is systemctl stop/start —
        # never pkill against the process (Nix wrapper names differ) or a second
        # uwsm-app owner. DESIRED automatic-lock preference is persisted under
        # XDG state and re-applied at graphical-session start by
        # leenix-desktop-state-apply. Manual System -> Lock (Hyprlock) stays
        # available regardless.

        STATE="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/toggles/automatic-lock.leenix"

        disable() {
          systemctl --user stop hypridle.service 2>/dev/null
          leenix-state set toggles/automatic-lock disabled 2>/dev/null || true
          notify-send -u low "󱫖    Stop locking computer when idle"
        }

        enable() {
          systemctl --user start hypridle.service 2>/dev/null
          leenix-state clear toggles/automatic-lock 2>/dev/null || true
          notify-send -u low "󱫖    Now locking computer when idle"
        }

        case "''${1:-toggle}" in
          on) enable ;;
          off) disable ;;
          toggle) if systemctl --user is-active --quiet hypridle.service; then disable; else enable; fi ;;
          apply)
            if [[ -f $STATE ]] && [[ $(cat "$STATE") == "disabled" ]]; then
              systemctl --user stop hypridle.service 2>/dev/null || true
            else
              systemctl --user start hypridle.service 2>/dev/null || true
            fi
            ;;
          *)
            echo "Usage: leenix-toggle-idle <on|off|toggle|apply>" >&2
            exit 1
            ;;
        esac

        pkill -RTMIN+9 waybar
      '';
    })
  ];
}
