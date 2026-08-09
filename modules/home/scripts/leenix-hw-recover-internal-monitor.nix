{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-recover-internal-monitor";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Clear the internal-monitor-disable toggle if no external display is connected.

        TOGGLE="$HOME/.local/state/leenix/toggles/hypr/internal-monitor-disable.conf"

        if [[ -f $TOGGLE ]] && ! leenix-hw-external-monitors; then
          rm -f "$TOGGLE"
        fi
      '';
    })
  ];
}