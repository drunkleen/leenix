{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-or-focus-webapp";
      excludeShellChecks = [ "SC2124" ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch or focus on a given web app identified by the window-pattern.

        # leenix:args=<window-pattern> <url-and-flags...>

        if (($# == 0)); then
          echo "Usage: leenix-launch-or-focus-webapp [window-pattern] [url-and-flags...]"
          exit 1
        fi

        WINDOW_PATTERN="$1"
        shift
        LAUNCH_COMMAND="leenix-launch-webapp $@"

        exec leenix-launch-or-focus "$WINDOW_PATTERN" "$LAUNCH_COMMAND"
      '';
    })
  ];
}