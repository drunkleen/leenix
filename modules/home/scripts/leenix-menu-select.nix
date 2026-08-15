{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu-select";

      runtimeInputs = with pkgs; [
        walker
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Pick one option with Walker

        # leenix:group=menu

        # leenix:name=select

        # leenix:args=prompt option... [-- walker args...]

        # leenix:examples=leenix menu select Format jpg png|leenix-menu-select Resolution 4k 1080p 720p -- --width 400

        set -euo pipefail

        if (( $# < 2 )); then
          echo "Usage: leenix-menu-select  ... [-- walker args...]" >&2
          exit 1
        fi

        prompt="$1"
        shift

        options=()
        walker_args=()

        while (( $# > 0 )); do
          if [[ $1 == "--" ]]; then
            shift
            walker_args=("$@")
            break
          fi

          options+=("$1")
          shift
        done

        if (( ''${#options[@]} == 0 )); then
          echo "Usage: leenix-menu-select  ... [-- walker args...]" >&2
          exit 1
        fi

        # Scoped compact theme + -e (exit after this dmenu call): the picker
        # closes after a selection or Escape and never touches the persistent
        # app-launcher service. Width is content-sized from prompt + options.
        width=$(printf '%s\n' "$prompt…" "''${options[@]}" | leenix-menu-width 2>/dev/null || echo 400)
        printf '%s\n' "''${options[@]}" | walker --dmenu -t leenix-menu --width "$width" --minheight 1 --maxheight 300 -e -p "$prompt…" "''${walker_args[@]}" 2>/dev/null
      '';
    })
  ];
}
