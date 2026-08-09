{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-bg-set";

      runtimeInputs = with pkgs; [
        coreutils
        procps
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set the current background image

        # leenix:args=

        # leenix:examples=leenix theme bg set ~/Pictures/wallpaper.png

        if [[ -z $1 ]]; then
          echo "Usage: leenix-theme-bg-set " >&2
          exit 1
        fi

        BACKGROUND="$(realpath "$1")"
        CURRENT_BACKGROUND_LINK="$HOME/.config/leenix/current/background"

        if [[ ! -f "$BACKGROUND" ]]; then
          echo "File does not exist: $BACKGROUND" >&2
          exit 1
        fi

        # Create symlink to the new background

        ln -nsf "$BACKGROUND" "$CURRENT_BACKGROUND_LINK"

        # Kill existing swaybg and start new one

        pkill -x swaybg
        setsid uwsm-app -- swaybg -i "$CURRENT_BACKGROUND_LINK" -m fill >/dev/null 2>&1 &
      '';
    })
  ];
}