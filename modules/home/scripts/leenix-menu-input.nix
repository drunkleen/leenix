{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu-input";

      runtimeInputs = with pkgs; [
        walker
      ];

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

        # Scoped compact theme + -e: closes after Enter/Escape, no service use.
        # Width from prompt + the MIN floor (keeps a usable typing field).
        width=$(printf '%s\n' "$prompt…" | leenix-menu-width 2>/dev/null || echo 400)
        walker --dmenu -t leenix-menu --inputonly --width "$width" --minheight 1 --maxheight 1 -e -p "$prompt…" "$@" 2>/dev/null
      '';
    })
  ];
}
