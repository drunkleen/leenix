{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-xbox-cloud";

      text = ''
        #!/bin/bash

        # leenix:summary=Remove legacy Xbox Cloud Gaming web app leftovers.

        set -e

        rm -f "$HOME/.local/share/applications/Xbox Cloud Gaming.desktop"
        rm -f "$HOME/.local/share/applications/icons/Xbox Cloud Gaming.png"
      '';
    })
  ];
}