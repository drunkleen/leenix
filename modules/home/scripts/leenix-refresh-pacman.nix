{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-pacman";

      runtimeInputs = with pkgs; [
        coreutils
        pacman
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the package configuration for /etc/pacman with the Leenix default of using its dedicated mirrors and repositories, then update all packages.

        # leenix:requires-sudo=true

        sudo cp -f /etc/pacman.conf /etc/pacman.conf.bak
        sudo cp -f /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

        channel="''${1:-stable}"

        if [[ $channel != "stable" && $channel != "rc" && $channel != "edge" ]]; then
          echo "Error: Invalid channel '$channel'. Must be one of: stable, rc, edge"
          exit 1
        fi

        echo "Setting channel to $channel"
        echo

        sudo cp -f "$LEENIX_PATH/default/pacman/pacman-$channel.conf" /etc/pacman.conf
        sudo cp -f "$LEENIX_PATH/default/pacman/mirrorlist-$channel" /etc/pacman.d/mirrorlist

        # Reset all package DBs and then update

        sudo pacman -Syyuu --noconfirm
      '';
    })
  ];
}