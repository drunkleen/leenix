{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-rebuild";
      excludeShellChecks = [ "SC2086" "SC2181" ];

      runtimeInputs = with pkgs; [
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Rebuild and activate the current LEENIX checkout (no git update).

        set -uo pipefail

        for arg in "$@"; do
          case "$arg" in
            --verbose) export LEENIX_DEBUG=1 ;;
            -h|--help)
              echo "Usage: leenix-rebuild [--verbose]"
              exit 0
              ;;
            *)
              echo "Unknown option: $arg" >&2
              exit 1
              ;;
          esac
        done

        LEENIX_SRC=''${LEENIX_SRC:-$HOME/nix-config}
        export LEENIX_SRC
        export LEENIX_TITLE=''${LEENIX_TITLE:-LEENIX Rebuild}

        cd "$LEENIX_SRC"

        leenix-system-apply
        rc=$?

        if [[ $rc -ne 0 ]]; then
          notify-send -u critical "LEENIX rebuild failed"
          exit "$rc"
        fi

        printf '\nSystem activated successfully.\n'
        notify-send -u normal "LEENIX rebuilt and switched"
      '';
    })
  ];
}
