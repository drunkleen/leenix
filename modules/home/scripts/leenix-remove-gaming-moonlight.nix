{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-moonlight";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove Moonlight and its configs and caches.

        # leenix:requires-sudo=true

        set -e

        leenix-pkg-drop moonlight-qt

        rm -rf \
          "$HOME/.config/Moonlight Game Streaming Project" \
          "$HOME/.cache/Moonlight Game Streaming Project"

        echo ""
        echo "Moonlight and its data have been removed."
      '';
    })
  ];
}