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

        # leenix:summary=Pick a system language and apply it through the Nix configuration transaction.

        set -euo pipefail

        # Display names and the locale value each maps to (declarative, single source).
        opts=(
          "English"
          "Deutsch"
          "فارسی"
        )
        vals=(
          "en_US.UTF-8"
          "de_DE.UTF-8"
          "fa_IR.UTF-8"
        )

        current=$(leenix-config get locale.default 2>/dev/null || true)

        idx=""
        for i in "''${!vals[@]}"; do
          [[ ''${vals[$i]} == "$current" ]] && idx=$((i + 1))
        done
        args=()
        [[ -n $idx ]] && args+=("-c" "$idx")

        selected=$(leenix-menu-select "Language" "''${opts[@]}" -- "''${args[@]}") || true
        [[ -n $selected ]] || exit 0

        sel=""
        for i in "''${!opts[@]}"; do
          [[ ''${opts[$i]} == "$selected" ]] && sel=''${vals[$i]}
        done
        [[ -n $sel && $sel != "$current" ]] || exit 0

        leenix-launch-floating-terminal-with-presentation leenix-config set locale.default "$sel"
      '';
    })
  ];
}
