{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-bg-install";

      runtimeInputs = with pkgs; [
        coreutils
        nautilus
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Open the current theme's user background folder

        CURRENT_THEME_NAME=$(cat "$HOME/.config/leenix/current/theme.name")
        THEME_USER_BACKGROUNDS="$HOME/.config/leenix/backgrounds/$CURRENT_THEME_NAME"

        mkdir -p "$THEME_USER_BACKGROUNDS"
        nautilus "$THEME_USER_BACKGROUNDS"
      '';
    })
  ];
}