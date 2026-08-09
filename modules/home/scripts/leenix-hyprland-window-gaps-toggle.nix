{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-window-gaps-toggle";

      text = ''
        #!/bin/bash

        # leenix:summary=Toggles the window gaps globally between no gaps and the default.

        leenix-hyprland-toggle window-no-gaps
      '';
    })
  ];
}