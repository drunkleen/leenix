{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-pkg-present";

      runtimeInputs = with pkgs; [
        pacman
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns true if all of the named packages are installed on the system (or false if any of them are missing).

        # leenix:args=<packages...>

        for pkg in "$@"; do
          pacman -Q "$pkg" &>/dev/null || exit 1
        done

        exit 0
      '';
    })
  ];
}