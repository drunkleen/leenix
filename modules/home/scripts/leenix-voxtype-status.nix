{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-voxtype-status";

      runtimeInputs = with pkgs; [
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Clean up the voxtype --follow child when Waybar reloads

        trap 'kill 0' EXIT

        if leenix-cmd-present voxtype; then
          voxtype status --follow --extended --format json |
            while read -r line; do
              echo "$line" | jq -c '. + {alt: .class}'
            done
        else
          echo '{"alt": "", "tooltip": ""}'
        fi
      '';
    })
  ];
}