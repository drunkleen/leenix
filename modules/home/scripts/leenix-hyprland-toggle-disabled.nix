{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-toggle-disabled";

      text = ''
        #!/bin/bash

        # leenix:summary=Check if a Hyprland toggle is currently disabled (missing).

        # leenix:args=

        [[ ! -f "$HOME/.local/state/leenix/toggles/hypr/''${1:-}.conf" ]]
      '';
    })
  ];
}