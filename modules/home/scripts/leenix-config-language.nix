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

        # leenix:summary=Pick the system language or regional formats and apply it through the Nix configuration transaction.

        # leenix:args=<language|region>

        set -euo pipefail

        # Display names and the locale value each maps to (declarative, single source).
        lang_opts=(
          "English"
          "Deutsch"
          "فارسی"
        )
        lang_vals=(
          "en_US.UTF-8"
          "de_DE.UTF-8"
          "fa_IR.UTF-8"
        )

        region_opts=(
          "Germany"
          "United States"
          "Iran"
        )
        region_vals=(
          "de_DE.UTF-8"
          "en_US.UTF-8"
          "fa_IR.UTF-8"
        )

        dimension=''${1:-language}
        case "$dimension" in
          language)
            opts=("''${lang_opts[@]}")
            vals=("''${lang_vals[@]}")
            key="locale.language"
            label="Language"
            ;;
          region)
            opts=("''${region_opts[@]}")
            vals=("''${region_vals[@]}")
            key="locale.region"
            label="Region & Formats"
            ;;
          *)
            echo "Usage: leenix-config-language <language|region>" >&2
            exit 1
            ;;
        esac

        current=$(leenix-config get "$key" 2>/dev/null || true)

        idx=""
        for i in "''${!vals[@]}"; do
          [[ ''${vals[$i]} == "$current" ]] && idx=$((i + 1))
        done
        args=()
        [[ -n $idx ]] && args+=("-c" "$idx")

        selected=$(leenix-menu-select "$label" "''${opts[@]}" -- "''${args[@]}") || true
        [[ -n $selected ]] || exit 0

        sel=""
        for i in "''${!opts[@]}"; do
          [[ ''${opts[$i]} == "$selected" ]] && sel=''${vals[$i]}
        done
        [[ -n $sel && $sel != "$current" ]] || exit 0

        leenix-launch-floating-terminal-with-presentation leenix-config locale "$dimension" "$sel"
      '';
    })
  ];
}
