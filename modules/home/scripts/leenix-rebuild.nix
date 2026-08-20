{ pkgs, leenix, ... }:

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

        # leenix:summary=Rebuild and activate the configured LEENIX instance (no git update).

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

        # Canonical instance metadata (baked from the typed leenix.instance.* tree
        # passed via the Home Manager bridge). CONFIG_NAME is consumed by
        # leenix-system-apply; this wrapper only locates the checkout.
        FLAKE="${leenix.instance.flakePath}"
        export FLAKE

        export LEENIX_TITLE=''${LEENIX_TITLE:-LEENIX Rebuild}

        cd "$FLAKE" || { echo "Instance checkout not found: $FLAKE" >&2; exit 1; }

        leenix-system-apply
        rc=$?

        if [[ $rc -ne 0 ]]; then
          notify-send -u critical "LEENIX rebuild failed"
          exit "$rc"
        fi

        printf '\nSystem rebuilt and activated.\n'
      '';
    })
  ];
}