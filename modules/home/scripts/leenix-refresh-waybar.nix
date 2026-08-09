{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-waybar";

      text = ''
        #!/bin/bash

        # leenix:summary=Reset Waybar config to Leenix defaults

        # leenix:examples=leenix refresh waybar

        leenix-refresh-config waybar/config.jsonc
        leenix-refresh-config waybar/style.css
        leenix-restart-waybar
      '';
    })
  ];
}