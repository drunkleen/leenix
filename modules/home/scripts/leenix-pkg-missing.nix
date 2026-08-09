{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-pkg-missing";

      runtimeInputs = with pkgs; [
        pacman
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns true if any of the named packages are missing from the system (or false if they're all there).

        # leenix:args=<packages...>

        for pkg in "$@"; do
          if ! pacman -Q "$pkg" &>/dev/null; then
            exit 0
          fi
        done

        exit 1
      '';
    })
  ];
}