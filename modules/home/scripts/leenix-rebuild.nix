{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-rebuild";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Rebuild and activate the current LEENIX checkout (no git update).

        set -euo pipefail

        LEENIX_SRC=''${LEENIX_SRC:-$HOME/nix-config}
        export LEENIX_SRC

        cd "$LEENIX_SRC"

        if ! leenix-system-apply; then
          notify-send -u critical "LEENIX rebuild failed"
          exit 1
        fi

        notify-send -u normal "LEENIX rebuilt and switched"
      '';
    })
  ];
}
