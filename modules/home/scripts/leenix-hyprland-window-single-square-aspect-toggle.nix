{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-window-single-square-aspect-toggle";

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle single-window square aspect ratio.

        leenix-hyprland-toggle \
          --enabled-notification "      Enable single-window square aspect ratio" \
          --disabled-notification "      Disable single-window square aspect ratio" \
          single-window-aspect-ratio
      '';
    })
  ];
}