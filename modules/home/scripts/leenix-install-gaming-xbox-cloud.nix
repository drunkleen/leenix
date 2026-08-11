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

        # leenix:summary=Launch Xbox Cloud Gaming in the default browser.

        set -e

        echo "Launching Xbox Cloud Gaming..."
        setsid leenix-launch-browser "https://www.xbox.com/en-US/play" >/dev/null 2>&1 &
      '';
    })
  ];
}