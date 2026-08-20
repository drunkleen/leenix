{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-config-language";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Configure language or region policy in the editor (or show the effective value).

        # leenix:args=<language|region>

        set -euo pipefail

        dimension=''${1:-language}
        case "$dimension" in
          language) label="Language"  key="locale.language" ;;
          region)   label="Region & Formats" key="locale.region" ;;
          *) echo "Usage: leenix-config-language <language|region>" >&2; exit 1 ;;
        esac

        selected=$(leenix-menu-select "$label" "󰵮  Show Current $label\n󰗄  Edit $label Policy") || true
        [[ -n $selected ]] || exit 0

        case "$selected" in
          *"Show Current"*)
            leenix-launch-floating-terminal-with-presentation leenix-config get "$key"
            ;;
          *"Edit"*)
            leenix-launch-floating-terminal-with-presentation leenix-config edit "$key"
            ;;
        esac
      '';
    })
  ];
}