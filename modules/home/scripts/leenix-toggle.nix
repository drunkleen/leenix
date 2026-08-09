{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle";

      runtimeInputs = with pkgs; [
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle Leenix features between enabled and disabled

        # leenix:args=[--enabled-notification ] [--disabled-notification ] 

        ENABLED_NOTIFICATION=""
        DISABLED_NOTIFICATION=""

        while [[ $# -gt 1 ]]; do
          case $1 in
            --enabled-notification)
              ENABLED_NOTIFICATION="$2"
              shift 2
              ;;
            --disabled-notification)
              DISABLED_NOTIFICATION="$2"
              shift 2
              ;;
            *)
              break
              ;;
          esac
        done

        FLAG_NAME="$1"
        FLAG="$HOME/.local/state/leenix/toggles/$FLAG_NAME"

        if [[ -f $FLAG ]]; then
          rm "$FLAG"
          [[ -n $DISABLED_NOTIFICATION ]] && notify-send -u low "$DISABLED_NOTIFICATION"
        else
          mkdir -p "$(dirname "$FLAG")"
          touch "$FLAG"
          [[ -n $ENABLED_NOTIFICATION ]] && notify-send -u low "$ENABLED_NOTIFICATION"
        fi
      '';
    })
  ];
}