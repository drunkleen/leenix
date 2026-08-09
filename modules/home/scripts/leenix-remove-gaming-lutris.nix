{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-lutris";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove Lutris, Wine, umu-launcher, and all their configs and caches.

        # leenix:requires-sudo=true

        set -e

        leenix-pkg-drop lutris wine-staging wine-mono wine-gecko winetricks python-protobuf umu-launcher

        rm -rf \
          "$HOME/.config/lutris" \
          "$HOME/.local/share/lutris" \
          "$HOME/.cache/lutris" \
          "$HOME/.local/share/umu" \
          "$HOME/.cache/umu" \
          "$HOME/.wine" \
          "$HOME/.cache/wine" \
          "$HOME/.cache/winetricks"

        echo ""
        echo "Lutris, Wine, umu-launcher, and their configs have been removed."
      '';
    })
  ];
}