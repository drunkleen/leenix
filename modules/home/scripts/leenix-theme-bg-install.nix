{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-bg-install";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Open the current theme's user background folder

        CURRENT_THEME_NAME=$(cat "$HOME/.config/leenix/current/theme.name")
        THEME_USER_BACKGROUNDS="$HOME/.config/leenix/backgrounds/$CURRENT_THEME_NAME"

        mkdir -p "$THEME_USER_BACKGROUNDS"
        leenix-launch-file-manager "$THEME_USER_BACKGROUNDS"
      '';
    })
  ];
}
