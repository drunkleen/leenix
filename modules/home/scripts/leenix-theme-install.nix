{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-install";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        git
        gum
        coreutils
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install a theme from a git repository

        # leenix:args=[git-repo-url]

        # leenix:examples=leenix theme install git@github.com:example/leenix-example-theme.git

        if [[ -z ''${1:-} ]]; then
          echo -e "\e[32mSee https://manuals.omamix.org/2/the-leenix-manual/90/extra-themes\n\e[0m"
          REPO_URL=$(gum input --placeholder="Git repo URL (https or git@host:org/repo.git)" --header="")
        else
          REPO_URL="$1"
        fi

        if [[ -z $REPO_URL ]]; then
          exit 1
        fi

        THEMES_DIR="$HOME/.config/leenix/themes"

        # Strip user@host: prefix from scp-style SSH URLs so basename sees just the path

        REPO_PATH="$REPO_URL"
        [[ $REPO_PATH != *"://"* && $REPO_PATH == *:*/* ]] && REPO_PATH="''${REPO_PATH#*:}"
        THEME_NAME=$(basename "$REPO_PATH" .git | sed -E 's/^leenix-//; s/-theme$//' | tr '[:upper:]' '[:lower:]')
        THEME_PATH="$THEMES_DIR/$THEME_NAME"

        # Remove existing theme if present

        if [[ -d $THEME_PATH ]]; then
          rm -rf "$THEME_PATH"
        fi

        # Clone the repo directly to ~/.config/leenix/themes

        if ! git clone "$REPO_URL" "$THEME_PATH"; then
          echo "Error: Failed to clone theme repo."
          exit 1
        fi

        # Apply the new theme with leenix-theme-set

        leenix-theme-set $THEME_NAME
      '';
    })
  ];
}