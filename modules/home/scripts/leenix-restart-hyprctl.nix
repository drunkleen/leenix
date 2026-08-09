{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-hyprctl";

      runtimeInputs = with pkgs; [
        hyprland
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reload hyprland configuration (used by the Leenix theme switching).

        hyprctl reload >/dev/null
      '';
    })
  ];
}