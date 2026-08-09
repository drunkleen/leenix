{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-toggle";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
        libnotify
        hyprland
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Toggle permanent Hyprland flags by copying them into a directory that's sourced entirely.

        # leenix:args=[--enabled-notification ] [--disabled-notification ] 

        ENABLED_NOTIFICATION=""
        DISABLED_NOTIFICATION=""

        while [[ $# -gt 1 ]]; do
          case $1 in
            --enabled-notification) ENABLED_NOTIFICATION="$2"; shift 2 ;;
            --disabled-notification) DISABLED_NOTIFICATION="$2"; shift 2 ;;
            *) break ;;
          esac
        done

        FLAG_NAME="$1"
        FLAG="$HOME/.local/state/leenix/toggles/hypr/$FLAG_NAME.conf"
        FLAG_SOURCE="$LEENIX_PATH/default/hypr/toggles/$FLAG_NAME.conf"

        if [[ -f $FLAG ]]; then
          rm $FLAG
          [[ -n $DISABLED_NOTIFICATION ]] && notify-send -u low "$DISABLED_NOTIFICATION"
        elif [[ -f $FLAG_SOURCE ]]; then
          cp $FLAG_SOURCE $FLAG
          [[ -n $ENABLED_NOTIFICATION ]] && notify-send -u low "$ENABLED_NOTIFICATION"
        else
          echo "Flag not found: $FLAG_NAME"
          exit 1
        fi

        hyprctl reload
      '';
    })
  ];
}