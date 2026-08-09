{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-reinstall-pkgs";

      runtimeInputs = with pkgs; [
        pacman
        gnugrep
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Reinstall all default Leenix packages from the stable channel

        # leenix:requires-sudo=true

        set -e

        # Reinstall all default Leenix packages from the stable channel and downgrade any packages that are too new.

        # Set the package repository to the stable mirrors

        leenix-refresh-pacman

        # Downgrade any packages to the stable setup

        sudo pacman -Suu --noconfirm

        # Ensure all packages are installed

        mapfile -t packages < <(
          grep -v '^#' "$LEENIX_PATH/install/leenix-base.packages" |
            grep -v '^$'
        )

        sudo pacman -Syu --noconfirm --needed "''${packages[@]}"
      '';
    })
  ];
}