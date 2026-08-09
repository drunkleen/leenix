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

        powerprofilesctl list |
          awk '/^\s*[\* ]\s*[a-zA-Z0-9-]+:$/ { gsub(/^[*[:space:]]+|:$/,""); print }' |
          tac
      '';
    })
  ];
}