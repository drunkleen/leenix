{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-opencode";

      runtimeInputs = with pkgs; [
        procps
        psmisc
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reload opencode configuration (used by the Leenix theme switching).

        if pgrep -x opencode >/dev/null; then
          killall -SIGUSR2 opencode
        fi
      '';
    })
  ];
}