{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-set-keyboard-asus-rog";
      excludeShellChecks = [ "SC2046" ];

      runtimeInputs = with pkgs; [
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Apply the current theme keyboard color to ASUS ROG keyboards

        # leenix:hidden=true

        ASUSCTL_THEME=~/.config/leenix/current/theme/keyboard.rgb

        if leenix-cmd-present asusctl; then
          asusctl aura effect static -c $(sed 's/^#//' $ASUSCTL_THEME)
        fi
      '';
    })
  ];
}