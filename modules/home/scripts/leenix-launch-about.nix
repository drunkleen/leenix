{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-about";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the fastfetch TUI that gives information about the current system.

        exec leenix-launch-or-focus-tui "bash -c 'fastfetch; read -n 1 -s'"
      '';
    })
  ];
}