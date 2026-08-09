{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-minecraft";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove the Minecraft launcher along with its worlds, mods, and caches.

        # leenix:requires-sudo=true

        set -e

        leenix-pkg-drop minecraft-launcher

        rm -rf \
          "$HOME/.minecraft" \
          "$HOME/.config/Minecraft Launcher" \
          "$HOME/.local/share/minecraft-launcher" \
          "$HOME/.cache/minecraft"

        echo ""
        echo "Minecraft and its data have been removed."
      '';
    })
  ];
}