{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-preinstalls";

      runtimeInputs = with pkgs; [
        gum
        coreutils
        hyprland
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Remove preinstalled Leenix applications (TUIs and selected packages).

        if gum confirm "Are you sure you want to remove all preinstalled TUI wrappers and desktop applications?"; then
          echo -e "Removing preinstalled Leenix applications...\n"

          leenix-tui-remove-all

          cp ~/.config/hypr/bindings.conf ~/.config/hypr/bindings.conf.bak
          cp "$LEENIX_PATH/default/hypr/plain-bindings.conf" ~/.config/hypr/bindings.conf
          hyprctl reload

          # Remove npx stubs

          rm -f ~/.local/bin/codex ~/.local/bin/gemini ~/.local/bin/copilot \
            ~/.local/bin/opencode ~/.local/bin/playwright-cli ~/.local/bin/pi

          leenix-pkg-drop \
            aether \
            cliamp \
            typora \
            spotify \
            libreoffice-fresh \
            1password-beta \
            1password-cli \
            xournalpp \
            signal-desktop \
            pinta \
            obsidian \
            obs-studio \
            kdenlive \
            lazydocker \
            opencode \
            claude-code
        fi
      '';
    })
  ];
}