{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-cmd-missing";

      text = ''
        #!/bin/bash

        # leenix:summary=Check whether any required commands are missing

        for cmd in "$@"; do
          if ! command -v "$cmd" &>/dev/null; then
            exit 0
          fi
        done

        exit 1
      '';
    })
  ];
}