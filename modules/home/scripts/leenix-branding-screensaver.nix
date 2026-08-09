{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-branding-screensaver";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Edit, set, or reset screensaver branding

        # leenix:group=branding

        # leenix:name=screensaver

        # leenix:args=<image|text|reset>

        # leenix:examples=leenix branding screensaver image | leenix branding screensaver text | leenix branding screensaver reset

        set -euo pipefail

        case "''${1:-}" in
          image)
            image=$(leenix-menu-file "Logo image" "$HOME" "svg png")
            if [[ -n $image ]] && leenix-transcode-ascii "$image" ~/.config/leenix/branding/screensaver.txt; then
              leenix-launch-screensaver force >/dev/null 2>&1
            fi
            ;;
          text)
            leenix-launch-editor ~/.config/leenix/branding/screensaver.txt >/dev/null 2>&1 && leenix-launch-screensaver force >/dev/null 2>&1
            ;;
          reset)
            cp "$LEENIX_PATH/logo.txt" ~/.config/leenix/branding/screensaver.txt && leenix-launch-screensaver force >/dev/null 2>&1
            ;;
          *)
            echo "Usage: leenix-branding-screensaver <image|text|reset>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}