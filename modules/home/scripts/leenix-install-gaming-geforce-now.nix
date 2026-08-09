{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-gaming-geforce-now";

      runtimeInputs = with pkgs; [
        coreutils
        curl
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install and launch Geforce Now.

        set -e

        echo "Installing GeForce NOW..."
        leenix-pkg-add flatpak
        cd /tmp

        # Download and run GeForce NOW

        curl -LO https://international.download.nvidia.com/GFNLinux/GeForceNOWSetup.bin
        chmod +x GeForceNOWSetup.bin
        ./GeForceNOWSetup.bin

        # Ensure a separate browser process not started by GFN is available.

        # If not, it seems like GFN has a tendency to hang on login.

        setsid leenix-launch-browser
      '';
    })
  ];
}