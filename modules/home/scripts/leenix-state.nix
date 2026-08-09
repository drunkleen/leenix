{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-state";

      runtimeInputs = with pkgs; [
        coreutils
        findutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage persistent state files for Leenix toggles and settings.

        # leenix:args=<set|clear>

        # leenix:hidden=true

        STATE_DIR="$HOME/.local/state/leenix"
        mkdir -p "$STATE_DIR"

        COMMAND=''${1:-}
        STATE_NAME=''${2:-}

        if [[ -z $COMMAND ]]; then
          echo "Usage: leenix-state <set|clear> <state-name>"
          exit 1
        fi

        if [[ -z $STATE_NAME ]]; then
          echo "Usage: leenix-state $COMMAND <state-name>"
          exit 1
        fi

        case "$COMMAND" in
          set)
            touch "$STATE_DIR/$STATE_NAME"
            ;;
          clear)
            find "$STATE_DIR" -maxdepth 1 -type f -name "$STATE_NAME" -delete
            ;;
        esac
      '';
    })
  ];
}