{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-tui";
      excludeShellChecks = [ "SC2046" "SC2086" ];

      runtimeInputs = with pkgs; [
        util-linux
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch a TUI command in the default terminal with Leenix styling

        # leenix:args= [args...]

        exec setsid uwsm-app -- xdg-terminal-exec --app-id=org.leenix.$(basename $1) -e "$1" "''${@:2}"
      '';
    })
  ];
}