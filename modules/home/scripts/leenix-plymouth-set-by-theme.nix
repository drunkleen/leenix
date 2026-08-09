{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-plymouth-set-by-theme";

      runtimeInputs = with pkgs; [
        gawk
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set the Plymouth boot theme from an Leenix theme

        # leenix:args=

        # leenix:requires-sudo=true

        # Resolve a theme by name and apply its unlock.png + colors.toml as the

        # Plymouth boot screen via leenix-plymouth-set.

        if [[ $# -ne 1 ]]; then
          echo "Usage: leenix-plymouth-set-by-theme " >&2
          exit 1
        fi

        theme=$1

        if [[ -d ~/.config/leenix/themes/$theme ]]; then
          theme_dir=~/.config/leenix/themes/$theme
        else
          theme_dir="$LEENIX_PATH/themes/$theme"
        fi

        bg=$(awk -F'"' '/^background/{print $2}' "$theme_dir/colors.toml")
        text=$(awk -F'"' '/^foreground/{print $2}' "$theme_dir/colors.toml")

        exec leenix-plymouth-set "$bg" "$text" "$theme_dir/unlock.png"
      '';
    })
  ];
}