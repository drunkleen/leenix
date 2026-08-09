{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-waybar";

      runtimeInputs = with pkgs; [
        procps
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle Waybar visibility

        # leenix:examples=leenix toggle waybar

        leenix-toggle waybar-off

        if pgrep -x waybar >/dev/null; then
          pkill -9 -x waybar
        else
          uwsm-app -- waybar >/dev/null 2>&1 &
        fi
      '';
    })
  ];
}