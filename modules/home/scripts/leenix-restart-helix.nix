{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-helix";

      runtimeInputs = with pkgs; [
        procps
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reload Helix configuration

        if pgrep -x helix >/dev/null; then
          pkill -USR1 helix
        fi
      '';
    })
  ];
}