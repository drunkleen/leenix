{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-editor";

      runtimeInputs = with pkgs; [
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the default editor as determined by $EDITOR (set via ~/.config/uwsm/default) (or nvim if missing).

        # leenix:args=

        leenix-cmd-present "$EDITOR" || EDITOR=nvim

        case "$EDITOR" in
          nvim | vim | nano | micro | hx | helix | fresh)
            exec leenix-launch-tui "$EDITOR" "$@"
            ;;
          *)
            exec setsid uwsm-app -- "$EDITOR" "$@"
            ;;
        esac
      '';
    })
  ];
}