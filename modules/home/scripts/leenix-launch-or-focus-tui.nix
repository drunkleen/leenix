{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-or-focus-tui";
      excludeShellChecks = [ "SC2124" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch a TUI or focus an existing terminal window for it

        # leenix:args= [args...]

        APP_ID="org.leenix.$(basename "''${1:-}")"
        LAUNCH_COMMAND="leenix-launch-tui $*"

        exec leenix-launch-or-focus "$APP_ID" "$LAUNCH_COMMAND"
      '';
    })
  ];
}