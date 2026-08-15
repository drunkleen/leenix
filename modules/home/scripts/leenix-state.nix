{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-state";

      runtimeInputs = with pkgs; [
        coreutils
        findutils
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Canonical LEENIX mutable runtime state helper (desired state).

        # leenix:args=<get|set|clear> <relpath> [value]

        # leenix:hidden=true

        # State root: ''${XDG_STATE_HOME:-$HOME/.local/state}/leenix
        # Layout: toggles/ hardware/ network/ desktop/ monitors/
        # Files use the .leenix suffix. Writes are atomic (tmp + mv).
        # These files represent DESIRED persistent runtime state, never a
        # substitute for the effective state of a real service/hardware.

        ROOT="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix"

        CMD=''${1:-}
        REL=''${2:-}
        VALUE=''${3:-}

        [[ -z $CMD || -z $REL ]] && {
          echo "Usage: leenix-state <get|set|clear> <relpath> [value]" >&2
          exit 1
        }

        # Prevent escaping the state root
        case "$REL" in
          /*|*..*) echo "invalid state path: $REL" >&2; exit 1 ;;
        esac

        FILE="$ROOT/$REL"
        [[ $FILE != *.leenix ]] && FILE="$FILE.leenix"

        case "$CMD" in
          get)
            [[ -f $FILE ]] && cat "$FILE" || exit 1
            ;;
          set)
            mkdir -p "$(dirname "$FILE")"
            tmp="$FILE.tmp.$$"
            if [[ -n $VALUE ]]; then
              printf '%s\n' "$VALUE" > "$tmp"
            else
              : > "$tmp"
            fi
            mv -f "$tmp" "$FILE"
            ;;
          clear)
            rm -f "$FILE"
            ;;
          *)
            echo "Usage: leenix-state <get|set|clear> <relpath> [value]" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
