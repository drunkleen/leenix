{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-walker";

      runtimeInputs = with pkgs; [
        systemd
        coreutils
        bash
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart the Walker launcher service

        restart_walker() {
          systemctl --user restart walker.service
        }

        if (( EUID == 0 )); then
          SCRIPT_OWNER=$(stat -c '%U' "$0")
          USER_UID=$(id -u "$SCRIPT_OWNER")
          systemd-run --uid="$SCRIPT_OWNER" --setenv=XDG_RUNTIME_DIR="/run/user/$USER_UID" \
            bash -c "$(declare -f restart_walker); restart_walker"
        else
          restart_walker
        fi
      '';
    })
  ];
}
