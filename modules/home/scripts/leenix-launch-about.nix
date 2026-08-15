{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-about";

      runtimeInputs = with pkgs; [
        leenfetch
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the leenfetch TUI that gives information about the current system.

        exec leenix-launch-or-focus-tui "bash -c 'leenfetch; read -n 1 -s'"
      '';
    })
  ];
}
