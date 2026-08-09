{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-snapshot";

      runtimeInputs = with pkgs; [
        snapper
        gawk
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Create or restore system snapshots with snapper

        # leenix:args=<create|restore>

        # leenix:requires-sudo=true

        set -e

        COMMAND="$1"
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        if [[ -z $COMMAND ]]; then
          echo "Usage: leenix-snapshot <create|restore>" >&2
          exit 1
        fi

        if ! command -v snapper &>/dev/null; then
          exit 127 # leenix-update can use this to just ignore if snapper is not available
        fi

        case "$COMMAND" in
          create)
            DESC="$(leenix-version)"

            echo -e "\e[32mCreate system snapshot\e[0m"

            # Get existing snapper config names from CSV output

            mapfile -t CONFIGS < <(sudo snapper --csvout list-configs | awk -F, 'NR>1 {print $1}')

            for config in "''${CONFIGS[@]}"; do
              sudo snapper -c "$config" create -c number -d "$DESC"
              sudo snapper -c "$config" cleanup number
            done
            echo
            ;;

          restore)
            sudo limine-snapper-restore
            ;;
        esac
      '';
    })
  ];
}