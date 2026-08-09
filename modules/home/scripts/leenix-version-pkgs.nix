{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-version-pkgs";

      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Print when system packages were last upgraded

        date -d "$(grep upgraded /var/log/pacman.log | tail -1 | sed -E 's/^[[]([^]]+)[]].*/\1/')" "+%A, %B %d %Y at %H:%M"
      '';
    })
  ];
}