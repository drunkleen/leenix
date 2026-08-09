{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-window-transparency-toggle";

      runtimeInputs = with pkgs; [
        hyprland
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggles transparency for the currently focused window.

        hyprctl dispatch setprop "address:$(hyprctl activewindow -j | jq -r '.address')" opaque toggle
      '';
    })
  ];
}