{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hook-install";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install a hook into ~/.config/leenix/hooks/.d/

        # leenix:group=hook

        # leenix:name=install

        # leenix:args=

        # leenix:examples=leenix hook install post-update ~/my-hook

        set -e

        if (( $# != 2 )); then
          echo "Usage: leenix-hook-install  "
          exit 1
        fi

        HOOK_TYPE=$1
        HOOK_FILE=$2
        HOOK_DIR="$HOME/.config/leenix/hooks/$HOOK_TYPE.d"
        HOOK_NAME=$(basename "$HOOK_FILE")
        HOOK_PATH="$HOOK_DIR/$HOOK_NAME"

        if [[ ! -f $HOOK_FILE ]]; then
          echo "Hook file not found: $HOOK_FILE"
          exit 1
        fi

        mkdir -p "$HOOK_DIR"
        cp "$HOOK_FILE" "$HOOK_PATH"
        chmod 755 "$HOOK_PATH"

        echo "Installed $HOOK_TYPE hook: $HOOK_PATH"
      '';
    })
  ];
}