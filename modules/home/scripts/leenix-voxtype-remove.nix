{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-voxtype-remove";

      runtimeInputs = with pkgs; [
        coreutils
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove Voxtype dictation and its configuration

        # leenix:requires-sudo=true

        set -e

        # Remove voxtype and its configurations.

        if leenix-cmd-present voxtype; then
          echo "Uninstall Voxtype to remove dictation."

          # Remove services

          systemctl --user stop voxtype.service 2>/dev/null || true
          rm -f "$HOME/.config/systemd/user/voxtype"*
          systemctl --user daemon-reload

          # Remove packages and configs

          leenix-pkg-drop wtype voxtype-bin
          rm -rf "$HOME/.config/voxtype"
          rm -rf "$HOME/.local/share/voxtype"
        else
          echo "Voxtype was not installed."
        fi
      '';
    })
  ];
}