{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu-input";

      text = ''
        #!/bin/bash

        # leenix:summary=Prompt for text input with Walker

        # leenix:group=menu

        # leenix:name=input

        # leenix:args=prompt [walker args...]

        # leenix:examples=leenix menu input Reminder|leenix-menu-input "Reminder in minutes" --width 400

        set -euo pipefail

        prompt="''${1:-Input}"
        if (( $# > 0 )); then
          shift
        fi

        leenix-launch-walker --dmenu --inputonly --width 295 --minheight 1 --maxheight 1 -p "$prompt…" "$@" 2>/dev/null
      '';
    })
  ];
}