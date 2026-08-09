{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-time";

      runtimeInputs = with pkgs; [
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart system time synchronization

        # leenix:requires-sudo=true

        echo "Updating time..."
        sudo systemctl restart systemd-timesyncd
      '';
    })
  ];
}