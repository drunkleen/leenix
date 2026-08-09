{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-drive-select";
      excludeShellChecks = [ "SC2124" ];

      runtimeInputs = with pkgs; [
        util-linux
        gnugrep
        coreutils
        gum
        gawk
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Select a drive from a list with info that includes space and brand. Used by leenix-drive-password.

        if (($# == 0)); then
          drives=$(lsblk -dpno NAME | grep -E '/dev/(sd|hd|vd|nvme|mmcblk|xv)')
        else
          drives="$@"
        fi

        drives_with_info=""
        while IFS= read -r drive; do
          [[ -n $drive ]] || continue
          drives_with_info+="$(leenix-drive-info "$drive")"$'\n'
        done <<<"$drives"

        selected_drive="$(printf "%s" "$drives_with_info" | gum choose --header "Select drive")" || exit 1
        printf "%s\n" "$selected_drive" | awk '{print $1}'
      '';
    })
  ];
}