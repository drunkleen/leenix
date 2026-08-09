{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-dev-add-migration";
      excludeShellChecks = [ "SC2086" "SC2164" ];

      runtimeInputs = with pkgs; [
        git
        coreutils
        neovim
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Creates a new Leenix migration named after the unix timestamp of the last commit.

        cd ~/.local/share/leenix
        migration_file="$HOME/.local/share/leenix/migrations/$(git log -1 --format=%cd --date=unix).sh"
        touch $migration_file

        if [[ "''${1:-}" != "--no-edit" ]]; then
          nvim $migration_file
        fi

        echo $migration_file
      '';
    })
  ];
}