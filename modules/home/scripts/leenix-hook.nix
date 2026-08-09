{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hook";
      excludeShellChecks = [ "SC2034" ];

      runtimeInputs = with pkgs; [
        bash
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Run a named hook from ~/.config/leenix/hooks/ and ~/.config/leenix/hooks/.d/.

        # leenix:args=[name] [args...]

        set -e

        if (( $# < 1 )); then
          echo "Usage: leenix-hook [name] [args...]"
          exit 1
        fi

        HOOK=$1
        HOOK_PATH="$HOME/.config/leenix/hooks/$1"
        HOOK_DIR="$HOOK_PATH.d"
        shift

        if [[ -f $HOOK_PATH ]]; then
          bash "$HOOK_PATH" "$@" || echo "Hook failed: $HOOK_PATH"
        fi

        if [[ -d $HOOK_DIR ]]; then
          for hook in "$HOOK_DIR"/*; do
            [[ -f $hook ]] || continue
            [[ $hook == *.sample ]] && continue
            bash "$hook" "$@" || echo "Hook failed: $hook"
          done
        fi
      '';
    })
  ];
}