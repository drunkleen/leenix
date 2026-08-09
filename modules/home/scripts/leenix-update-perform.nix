{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-perform";

      text = ''
        #!/bin/bash

        # leenix:summary=Run the full Leenix update pipeline

        # leenix:requires-sudo=true

        set -e

        # Ensure screensaver/sleep doesn't set in during updates

        hyprctl dispatch tagwindow +noidle &>/dev/null || true

        # Perform all update steps

        leenix-update-keyring
        leenix-update-available-reset
        leenix-update-system-pkgs
        leenix-migrate
        leenix-update-aur-pkgs
        leenix-update-orphan-pkgs
        leenix-hook post-update

        leenix-update-analyze-logs

        leenix-update-restart

        # Re-enable screensaver/sleep after updates

        hyprctl dispatch tagwindow -- -noidle &>/dev/null || true
      '';
    })
  ];
}