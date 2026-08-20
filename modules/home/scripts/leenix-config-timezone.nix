{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-config-timezone";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Configure the timezone policy in the editor (or show the effective value).

        set -euo pipefail

        selected=$(leenix-menu-select "Timezone" "󰵮  Show Current Timezone\n󰥔  Edit Timezone Policy") || true
        [[ -n $selected ]] || exit 0

        case "$selected" in
          *"Show Current Timezone"*)
            leenix-launch-floating-terminal-with-presentation leenix-config get timezone
            ;;
          *"Edit Timezone Policy"*)
            leenix-launch-floating-terminal-with-presentation leenix-config edit timezone
            ;;
        esac
      '';
    })
  ];
}