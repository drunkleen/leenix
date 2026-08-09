{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-enabled";

      text = ''
        #!/bin/bash

        # leenix:summary=Check if a toggle is enabled (flag file exists)

        # leenix:args=

        [[ -f "$HOME/.local/state/leenix/toggles/$1" ]]
      '';
    })
  ];
}