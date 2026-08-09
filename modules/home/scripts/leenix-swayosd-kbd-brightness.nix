{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-swayosd-kbd-brightness";

      runtimeInputs = with pkgs; [
        gawk
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Display keyboard brightness level using SwayOSD on the current monitor.

        # leenix:args=<0-100>

        # leenix:examples=leenix swayosd kbd brightness 0 | leenix swayosd kbd brightness 50 | leenix swayosd kbd brightness 100

        percent=''${1:-}

        progress="$(awk -v p="$percent" 'BEGIN{printf "%.2f", p/100}')"
        [[ $progress == "0.00" ]] && progress="0.01"

        leenix-swayosd-client \
          --custom-icon keyboard-brightness-symbolic \
          --custom-progress "$progress" \
          --custom-progress-text "''${percent}%"
      '';
    })
  ];
}