{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-config-dns";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Configure DNS policy in the editor (or show the effective value).

        set -euo pipefail

        selected=$(leenix-menu-select "DNS" "󰵮  Show Current DNS\n󰣹  Edit DNS Policy") || true
        [[ -n $selected ]] || exit 0

        case "$selected" in
          *"Show Current DNS"*)
            leenix-launch-floating-terminal-with-presentation leenix-config dns show
            ;;
          *"Edit DNS Policy"*)
            leenix-launch-floating-terminal-with-presentation leenix-config dns
            ;;
        esac
      '';
    })
  ];
}