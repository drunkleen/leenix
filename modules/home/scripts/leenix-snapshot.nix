{ pkgs, leenix, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-snapshot";

      runtimeInputs = with pkgs; [
        snapper
        gawk
        coreutils
        git
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Create or restore system snapshots with snapper

        # leenix:args=<create|restore>

        # leenix:requires-sudo=true

        set -e

        COMMAND=''${1:-}

        # Canonical LEENIX instance checkout (baked from the typed
        # leenix.instance.* tree passed via the Home Manager bridge).
        FLAKE="${leenix.instance.flakePath}"

        if [[ -z $COMMAND ]]; then
          echo "Usage: leenix-snapshot <create|restore>" >&2
          exit 1
        fi

        if ! command -v snapper &>/dev/null; then
          echo "snapper is not installed" >&2
          exit 127
        fi

        case "$COMMAND" in
          create)
            DESC="$(git -C "$FLAKE" rev-parse --short HEAD 2>/dev/null || echo manual)"

            echo -e "\e[32mCreate system snapshot\e[0m"

            # Get existing snapper config names from CSV output
            mapfile -t CONFIGS < <(sudo snapper --csv list-configs | awk -F, 'NR>1 {print $1}')

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