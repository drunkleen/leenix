{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-branding-about";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Edit, set, or reset About branding

        # leenix:group=branding

        # leenix:name=about

        # leenix:args=<image|text|reset>

        # leenix:examples=leenix branding about image | leenix branding about text | leenix branding about reset

        set -euo pipefail

        case "''${1:-}" in
          image)
            image=$(leenix-menu-file "Logo image" "$HOME" "svg png")
            if [[ -n $image ]] && leenix-transcode-ascii "$image" ~/.config/leenix/branding/about.txt --width 54 --height 26 --mode block; then
              leenix-launch-about >/dev/null 2>&1
            fi
            ;;
          text)
            leenix-launch-editor ~/.config/leenix/branding/about.txt >/dev/null 2>&1 && leenix-launch-about >/dev/null 2>&1
            ;;
          reset)
            cp "$LEENIX_PATH/icon.txt" ~/.config/leenix/branding/about.txt && leenix-launch-about >/dev/null 2>&1
            ;;
          *)
            echo "Usage: leenix-branding-about <image|text|reset>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}