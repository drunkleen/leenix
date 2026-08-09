{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu-select";

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

        printf '%s\n' "''${options[@]}" | leenix-launch-walker --dmenu --width 295 --minheight 1 --maxheight 300 -p "$prompt…" "''${walker_args[@]}" 2>/dev/null
      '';
    })
  ];
}