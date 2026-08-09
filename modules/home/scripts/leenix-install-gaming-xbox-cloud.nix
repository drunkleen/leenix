{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-gaming-xbox-cloud";

      runtimeInputs = with pkgs; [
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Xbox Cloud Gaming as a web app and launch it.

        set -e

        echo "Installing Xbox Cloud Gaming..."
        leenix-webapp-install \
          "Xbox Cloud Gaming" \
          "https://www.xbox.com/en-US/play" \
          "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/xbox.png"

        setsid leenix-launch-webapp "https://www.xbox.com/en-US/play" >/dev/null 2>&1 &
      '';
    })
  ];
}