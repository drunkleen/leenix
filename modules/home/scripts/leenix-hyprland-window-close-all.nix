{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-window-close-all";

      runtimeInputs = with pkgs; [
        hyprland
        jq
        findutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Close all open windows

        hyprctl clients -j | \
          jq -r ".[].address" | \
          xargs -I{} hyprctl dispatch closewindow address:{}

        # Move to first workspace

        hyprctl dispatch workspace 1
      '';
    })
  ];
}