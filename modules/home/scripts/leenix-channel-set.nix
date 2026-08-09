{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-channel-set";

      text = ''
        #!/bin/bash

        # leenix:summary=Set the Leenix channel, which dictates what git branch and package repository is used.

        # leenix:args=<stable|rc|edge|dev>

        # leenix:requires-sudo=true

        if (($# == 0)); then
          echo "Usage: leenix-channel-set [stable|rc|edge|dev]"
          exit 1
        else
          channel="$1"
        fi

        case "$channel" in
          "stable") leenix-branch-set "master" && leenix-refresh-pacman "stable" ;;
          "rc") leenix-branch-set "rc" && leenix-refresh-pacman "rc" ;;
          "edge") leenix-branch-set "master" && leenix-refresh-pacman "edge" ;;
          "dev") leenix-branch-set "dev" && leenix-refresh-pacman "edge" ;;
          *) echo "Unknown channel: $channel"; exit 1; ;;
        esac

        leenix-update -y
      '';
    })
  ];
}