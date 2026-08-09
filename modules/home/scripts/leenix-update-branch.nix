{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-branch";

      runtimeInputs = with pkgs; [
        git
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Switch Leenix branches and update from the selected branch

        # leenix:args=

        set -e

        if (($# == 0)); then
          echo "Usage: leenix-update-branch [master|dev]"
          exit 1
        fi

        branch="$1"

        # Snapshot before switching branch

        leenix-snapshot create || (( $? == 127 ))

        if ! git -C "$LEENIX_PATH" diff --quiet ||
           ! git -C "$LEENIX_PATH" diff --cached --quiet; then
          stashed=true
          git -C "$LEENIX_PATH" stash push -u -m "Autostash before switching to $branch"
        else
          stashed=false
        fi

        # Switch branches

        git -C "$LEENIX_PATH" switch "$branch"

        # Reapply stash if we made one

        if [[ $stashed == "true" ]]; then
          if ! git -C "$LEENIX_PATH" stash pop; then
            echo "⚠️ Conflicts when applying stash — stash kept"
          fi
        fi

        # Update the system from the new branch

        leenix-update-perform
      '';
    })
  ];
}