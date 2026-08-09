{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-steam";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove Steam and all of its game libraries, configs, and caches.

        # leenix:requires-sudo=true

        set -e

        leenix-pkg-drop steam

        rm -rf \
          "$HOME/.steam" \
          "$HOME/.local/share/Steam" \
          "$HOME/.config/steam" \
          "$HOME/.cache/steam"

        echo ""
        echo "Steam and its data have been removed."
      '';
    })
  ];
}