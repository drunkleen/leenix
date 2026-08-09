{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-tmux";

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user tmux config with the Leenix default and reload tmux.

        leenix-refresh-config tmux/tmux.conf
        leenix-restart-tmux
      '';
    })
  ];
}