{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-system-pkgs";

      runtimeInputs = with pkgs; [
        pacman
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Update system packages with pacman

        # leenix:requires-sudo=true

        set -e

        echo -e "\e[32m\nUpdate system packages\e[0m"
        sudo pacman -Syyu --noconfirm
      '';
    })
  ];
}