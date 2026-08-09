{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-set-obsidian";

      runtimeInputs = with pkgs; [
        jq
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Sync Leenix theme to all Obsidian vaults

        # leenix:hidden=true

        CURRENT_THEME_DIR="$HOME/.config/leenix/current/theme"

        [[ -f $CURRENT_THEME_DIR/obsidian.css ]] || exit 0

        jq -r '.vaults | values[].path' ~/.config/obsidian/obsidian.json 2>/dev/null | while read -r vault_path; do
          [[ -d $vault_path/.obsidian ]] || continue

          theme_dir="$vault_path/.obsidian/themes/Leenix"
          mkdir -p "$theme_dir"

          [[ -f $theme_dir/manifest.json ]] || cat >"$theme_dir/manifest.json" <<'EOF'
        {
        "name": "Leenix",
        "version": "1.0.0",
        "minAppVersion": "0.16.0",
        "description": "Automatically syncs with your current Leenix system theme colors and fonts",
        "author": "Leenix",
        "authorUrl": "https://leenix.org"
        }
        EOF

          cp "$CURRENT_THEME_DIR/obsidian.css" "$theme_dir/theme.css"
        done
      '';
    })
  ];
}