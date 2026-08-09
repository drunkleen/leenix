{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-tmux";

      runtimeInputs = with pkgs; [
        procps
        tmux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart tmux if running with the latest configuration

        if pgrep -x tmux; then
          tmux source-file ~/.config/tmux/tmux.conf
        fi
      '';
    })
  ];
}