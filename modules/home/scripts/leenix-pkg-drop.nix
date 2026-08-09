{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-pkg-drop";

      runtimeInputs = with pkgs; [
        pacman
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove all the named packages from the system if they're installed (otherwise ignore).

        # leenix:args=<packages...>

        # leenix:requires-sudo=true

        installed=()
        for pkg in "$@"; do
          if pacman -Qq | grep -Fxq "$pkg"; then
            installed+=("$pkg")
          fi
        done

        if (( ''${#installed[@]} > 0 )); then
          sudo pacman -Rns --noconfirm "''${installed[@]}"
        fi
      '';
    })
  ];
}