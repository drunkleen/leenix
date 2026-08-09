{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-gaming-heroic";

      runtimeInputs = with pkgs; [
        util-linux
        gtk3
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Heroic Games Launcher (Epic, GOG, Amazon Prime Gaming) with graphics drivers.

        # leenix:requires-sudo=true

        set -e

        echo "Installing Heroic Games Launcher..."
        leenix-pkg-add heroic-games-launcher-bin
        leenix-install-gaming-gpu-lib32

        setsid gtk-launch heroic >/dev/null 2>&1 &
      '';
    })
  ];
}