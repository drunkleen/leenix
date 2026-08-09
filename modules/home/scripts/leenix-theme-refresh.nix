{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-refresh";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Refresh the current theme from its templates.

        THEME_NAME_PATH="$HOME/.config/leenix/current/theme.name"

        if [[ -f $THEME_NAME_PATH ]]; then
          LEENIX_THEME_SKIP_BACKGROUND=1 leenix-theme-set "$(cat $THEME_NAME_PATH)"
        fi
      '';
    })
  ];
}