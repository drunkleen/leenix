{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-list";

      runtimeInputs = with pkgs; [
        findutils
        coreutils
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=List available themes

        # leenix:examples=leenix theme list | leenix theme set "Tokyo Night"

        {
          find ~/.config/leenix/themes/ -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -printf '%f\n'
          find "$LEENIX_PATH/themes/" -mindepth 1 -maxdepth 1 -type d -printf '%f\n'
        } | sort -u | while read -r name; do
          echo "$name" | sed -E 's/(^|-)([a-z])/\1\u\2/g; s/-/ /g'
        done
      '';
    })
  ];
}