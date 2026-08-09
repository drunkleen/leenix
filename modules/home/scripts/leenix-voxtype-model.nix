{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-voxtype-model";

      text = ''
        #!/bin/bash

        # leenix:summary=Open Voxtype AI model setup

        set -e

        leenix-launch-floating-terminal-with-presentation "voxtype setup model"
        leenix-restart-waybar
      '';
    })
  ];
}