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

        # Waybar's real process name is .waybar-wrapped (the `waybar` bin is a
        # wrapper that execs it), so exact `-x waybar` would never match.
        pkill -9 -x .waybar-wrapped
        setsid uwsm-app -- waybar >/dev/null 2>&1 &
      '';
    })
  ];
}