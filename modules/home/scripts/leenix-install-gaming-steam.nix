{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-gaming-steam";

      runtimeInputs = with pkgs; [
        util-linux
        gtk3
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Steam and graphics drivers selected for this system

        # leenix:requires-sudo=true

        set -e

        echo "Installing Steam..."
        leenix-pkg-add steam
        leenix-install-gaming-gpu-lib32

        echo ""
        echo "Steam will start automatically now. This might take a while..."

        setsid gtk-launch steam >/dev/null 2>&1 &
      '';
    })
  ];
}