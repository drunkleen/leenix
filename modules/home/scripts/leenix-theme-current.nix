{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-current";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Show current theme

        # leenix:examples=leenix theme current

        THEME_NAME_PATH="$HOME/.config/leenix/current/theme.name"

        if [[ -f $THEME_NAME_PATH ]]; then
          cat $THEME_NAME_PATH | sed -E 's/(^|-)([a-z])/\1\u\2/g; s/-/ /g'
        else
          echo "Unknown"
        fi
      '';
    })
  ];
}