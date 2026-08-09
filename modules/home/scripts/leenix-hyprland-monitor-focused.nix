{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-monitor-focused";

      runtimeInputs = with pkgs; [
        hyprland
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Print the name of the currently focused Hyprland monitor.

        hyprctl monitors -j | jq -r '.[] | select(.focused == true).name'
      '';
    })
  ];
}