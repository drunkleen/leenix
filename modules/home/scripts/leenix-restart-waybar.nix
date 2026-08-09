{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-waybar";

      runtimeInputs = with pkgs; [
        procps
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart Waybar

        # leenix:examples=leenix restart waybar

        pkill -9 -x waybar
        setsid uwsm-app -- waybar >/dev/null 2>&1 &
      '';
    })
  ];
}