{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-config-timezone";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Pick a timezone and apply it through the Nix configuration transaction.

        set -euo pipefail

        current=$(leenix-config get timezone 2>/dev/null || true)
        mapfile -t zones < <(timedatectl list-timezones)

        index=$(printf '%s\n' "''${zones[@]}" | grep -nxF "$current" | cut -d: -f1 || true)
        args=()
        [[ -n $index ]] && args+=("-c" "$index")

        selected=$(leenix-menu-select "Timezone" "''${zones[@]}" -- "''${args[@]}") || true
        [[ -n $selected && $selected != "$current" ]] || exit 0

        leenix-launch-floating-terminal-with-presentation leenix-config set timezone "$selected"
      '';
    })
  ];
}
