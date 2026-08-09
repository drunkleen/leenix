{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-voxtype-config";

      runtimeInputs = [
        pkgs.coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Open the Voxtype configuration file

        set -e

        # Used by Voxtype waybar module to open config on right click

        exec leenix-launch-editor "$HOME/.config/voxtype/config.toml"
      '';
    })
  ];
}