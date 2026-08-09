{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-floating-terminal-with-presentation";

      runtimeInputs = with pkgs; [
        util-linux
        bash
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch a floating terminal with the Leenix presentation wrapper

        # leenix:args=

        cmd="$*"
        exec setsid uwsm-app -- xdg-terminal-exec \
          --app-id=org.leenix.terminal \
          --title=Leenix \
          -e bash -c "leenix-show-logo; $cmd; if (( \$? != 130 )); then leenix-show-done; fi"
      '';
    })
  ];
}