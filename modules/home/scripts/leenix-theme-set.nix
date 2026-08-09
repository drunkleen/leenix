{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-set";

      runtimeInputs = with pkgs; [
        coreutils
        gnused
        procps
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Apply an Leenix theme

        # leenix:args=

        # leenix:examples=leenix theme list | leenix theme set "Tokyo Night"

        if [[ -z $1 ]]; then
          echo "Usage: leenix-theme-set "
          exit 1
        fi

        CURRENT_THEME_PATH="$HOME/.config/leenix/current/theme"
        NEXT_THEME_PATH="$HOME/.config/leenix/current/next-theme"
        USER_THEMES_PATH="$HOME/.config/leenix/themes"
        LEENIX_THEMES_PATH="$LEENIX_PATH/themes"

        THEME_NAME=$(echo "$1" | sed -E 's/<[^>]+>//g' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

        if [[ ! -d $LEENIX_THEMES_PATH/$THEME_NAME ]] && [[ ! -d $USER_THEMES_PATH/$THEME_NAME ]]; then
          echo "Theme '$THEME_NAME' does not exist"
          exit 1
        fi

        # Setup clean next theme directory (for atomic theme config swapping)

        rm -rf "$NEXT_THEME_PATH"
        mkdir -p "$NEXT_THEME_PATH"

        # Copy official theme first, then overlay user customizations on top

        cp -r "$LEENIX_THEMES_PATH/$THEME_NAME/"* "$NEXT_THEME_PATH/" 2>/dev/null
        cp -r "$USER_THEMES_PATH/$THEME_NAME/"* "$NEXT_THEME_PATH/" 2>/dev/null

        # Generate colors.toml from alacritty.toml if theme is missing colors.toml

        if [[ ! -f $NEXT_THEME_PATH/colors.toml && -f $NEXT_THEME_PATH/alacritty.toml ]]; then
          leenix-theme-colors-from-alacritty "$NEXT_THEME_PATH"
        fi

        # Generate dynamic configs

        leenix-theme-set-templates

        # Swap next theme in as current

        rm -rf "$CURRENT_THEME_PATH"
        mv "$NEXT_THEME_PATH" "$CURRENT_THEME_PATH"

        # Store theme name for reference

        echo "$THEME_NAME" >"$HOME/.config/leenix/current/theme.name"

        # Change background with theme

        if [[ ''${LEENIX_THEME_SKIP_BACKGROUND:-} != "1" ]]; then
          leenix-theme-bg-next
        fi

        # Restart components to apply new theme

        if pgrep -x waybar >/dev/null; then
          leenix-restart-waybar
        fi
        leenix-restart-swayosd
        leenix-restart-terminal
        leenix-restart-hyprctl
        leenix-restart-btop
        leenix-restart-opencode
        leenix-restart-mako
        leenix-restart-helix

        # Change app-specific themes

        leenix-theme-set-foot
        leenix-theme-set-gnome
        leenix-theme-set-browser
        leenix-theme-set-vscode
        leenix-theme-set-obsidian
        leenix-theme-set-keyboard

        # Call hook on theme set

        leenix-hook theme-set "$THEME_NAME" >/dev/null
      '';
    })
  ];
}