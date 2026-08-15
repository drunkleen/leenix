{
  lib,
  pkgs,
  ...
}:

let
  watchCmd = pkgs.writeShellApplication {
    name = "leenix-monitor-state-watch";

    runtimeInputs = with pkgs; [
      socat
      coreutils
      jq
      hyprland
    ];

    text = ''
      #!/bin/bash

      # leenix:summary=Watch Hyprland monitor events and reconcile desired vs effective monitor topology

      # Reconcile once at startup (also covers a graphical-session restart).
      leenix-monitor reconcile 2>/dev/null || true

      instance=$(hyprctl instances -j 2>/dev/null | jq -r '.[0].instance // empty')
      if [[ -z $instance ]]; then
        echo "leenix-monitor-state-watch: no Hyprland instance" >&2
        exit 1
      fi

      socket="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/$instance/.socket2.sock"
      if [[ ! -S $socket ]]; then
        echo "leenix-monitor-state-watch: event socket not found: $socket" >&2
        exit 1
      fi

      echo "leenix-monitor-state-watch: watching $socket"

      last_apply=0
      socat -u "UNIX-CONNECT:$socket" - | while IFS= read -r line; do
        case "$line" in
          monitoradded*|monitorremoved*)
            # Debounce bursts (e.g. dock attach events) to at most every 500ms.
            now=$(date +%s%3N)
            (( now - last_apply >= 500 )) || continue
            last_apply=$now
            echo "leenix-monitor-state-watch: $line -> reconciling"
            leenix-monitor reconcile 2>/dev/null || true
            # Refresh wallpaper on the (possibly changed) output topology.
            if command -v leenix-wallpaper-refresh >/dev/null 2>&1; then
              leenix-wallpaper-refresh 2>/dev/null || true
            fi
            # An external monitor may still be activating when monitoradded
            # fires; reconcile again briefly so the saved desired topology is
            # applied once the display is usable (bounded, no long sleeps).
            if [[ $line == monitoradded* ]]; then
              for _ in 1 2 3 4; do
                sleep 0.5
                leenix-monitor reconcile 2>/dev/null || true
              done
            fi
            ;;
        esac
      done
    '';
  };
in
{
  home.packages = [
    watchCmd
  ];

  systemd.user.services.leenix-monitor-state-watch = {
    Unit = {
      Description = "LEENIX monitor hotplug state watcher (HyprMon reconciliation)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe watchCmd}";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
