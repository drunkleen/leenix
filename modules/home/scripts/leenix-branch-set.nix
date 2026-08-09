{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-branch-set";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        git
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set the branch for Leenix's git repository.

        # leenix:args=<master|rc|dev>

        if (($# == 0)); then
          echo "Usage: leenix-branch-set [master|rc|dev]"
          exit 1
        else
          branch="$1"
        fi

        if [[ $branch != "master" && $branch != "rc" && $branch != "dev" ]]; then
          echo "Error: Invalid branch '$branch'. Must be one of: master, rc, dev"
          exit 1
        fi

        git -C $LEENIX_PATH switch $branch
      '';
    })
  ];
}