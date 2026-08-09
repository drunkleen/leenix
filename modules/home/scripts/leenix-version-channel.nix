{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-version-channel";
      excludeShellChecks = [ "SC2053" ];

      runtimeInputs = with pkgs; [
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Print the active Leenix mirror and package channel

        if grep -q "https://stable-mirror.leenix.org/" /etc/pacman.d/mirrorlist; then
          mirror="stable"
        elif grep -q "https://rc-mirror.leenix.org/" /etc/pacman.d/mirrorlist; then
          mirror="rc"
        elif grep -q "https://mirror.leenix.org/" /etc/pacman.d/mirrorlist; then
          mirror="edge"
        else
          mirror="unknown"
        fi

        if grep -q "https://pkgs.leenix.org/stable/" /etc/pacman.conf; then
          pkgs="stable"
        elif grep -q "https://pkgs.leenix.org/edge/" /etc/pacman.conf; then
          pkgs="edge"
        elif grep -q "https://pkgs.leenix.org/rc/" /etc/pacman.conf; then
          pkgs="rc"
        else
          pkgs="unknown"
        fi

        if [[ $mirror == $pkgs ]]; then
          echo "$mirror"
        else
          echo "$mirror / $pkgs"
        fi
      '';
    })
  ];
}