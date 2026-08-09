{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-heroic";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove Heroic Games Launcher and its game libraries, configs, and caches.

        # leenix:requires-sudo=true

        set -e

        leenix-pkg-drop heroic-games-launcher-bin

        rm -rf \
          "$HOME/.config/heroic" \
          "$HOME/.local/share/heroic" \
          "$HOME/.cache/heroic" \
          "$HOME/Games/Heroic"

        echo ""
        echo "Heroic and its data have been removed."
      '';
    })
  ];
}