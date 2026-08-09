{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-audio";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the Leenix audio controls TUI (provided by wiremix).

        leenix-launch-or-focus-tui wiremix
      '';
    })
  ];
}