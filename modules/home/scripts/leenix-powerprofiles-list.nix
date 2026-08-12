{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-powerprofiles-list";

      runtimeInputs = with pkgs; [
        power-profiles-daemon
        gawk
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns a list of all the available power profiles on the system.

        if ! output=$(powerprofilesctl list 2>&1); then
          echo "error: $output" >&2
          exit 1
        fi

        printf '%s\n' "$output" |
          awk '/^\s*[\* ]\s*[a-zA-Z0-9-]+:$/ { gsub(/^[*[:space:]]+|:$/,""); print }' |
          tac
      '';
    })
  ];
}