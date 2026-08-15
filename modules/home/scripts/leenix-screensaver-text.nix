{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-screensaver-text";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage custom screensaver text (custom text overrides the canonical LEENIX logo)

        # leenix:args=<show|set|reset>

        STATE="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/desktop/screensaver-text.leenix"

        case "''${1:-show}" in
          show)
            if [[ -f $STATE ]]; then
              echo "custom screensaver text:"
              echo "---"
              cat "$STATE"
              echo "---"
            else
              echo "using canonical LEENIX logo"
            fi
            ;;
          set)
            text="''${2:-}"
            if [[ -z $text ]]; then
              text=$(leenix-menu-input "Screensaver text" 2>/dev/null || echo "")
            fi
            [[ -n $text ]] || { echo "empty text; nothing changed" >&2; exit 1; }
            mkdir -p "$(dirname "$STATE")"
            printf '%s\n' "$text" > "$STATE.tmp"
            mv -f "$STATE.tmp" "$STATE"
            echo "screensaver text set"
            ;;
          reset)
            rm -f "$STATE"
            echo "reset to canonical LEENIX logo"
            ;;
          *)
            echo "Usage: leenix-screensaver-text <show|set|reset> [text]" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
