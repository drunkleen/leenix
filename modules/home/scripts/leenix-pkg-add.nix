{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-pkg-add";

      runtimeInputs = with pkgs; [
        pacman
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Arch packages if they are missing

        # leenix:args=<packages...>

        # leenix:examples=leenix pkg add jq ripgrep

        # leenix:requires-sudo=true

        if leenix-pkg-missing "$@"; then
          sudo pacman -S --noconfirm --needed "$@" || exit 1
        fi

        for pkg in "$@"; do

          # Secondary check to handle states where pacman doesn't actually register an error

          if ! pacman -Q "$pkg" &>/dev/null; then
            echo -e "\033[31mError: Package '$pkg' did not install\033[0m" >&2
            exit 1
          fi
        done

        exit 0
      '';
    })
  ];
}