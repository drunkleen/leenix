{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-helix";

      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Helix and configure it to use the current Leenix theme

        echo "Installing Helix..."
        leenix-pkg-add helix

        mkdir -p ~/.config/helix/themes

        # Symlink the rendered Leenix theme so Helix tracks the active theme

        ln -sf ~/.config/leenix/current/theme/helix.toml ~/.config/helix/themes/leenix.toml

        # Only seed a config.toml if the user does not already have one

        if [[ ! -f ~/.config/helix/config.toml ]]; then
          cat >~/.config/helix/config.toml <<'EOF'
        theme = "leenix"
        EOF
        fi

        # Ensure the symlink target exists for users whose current theme predates this template

        if [[ ! -e ~/.config/leenix/current/theme/helix.toml ]]; then
          leenix-theme-refresh
        fi

        # Arch-based distros ship Helix as 'helix' rather than the upstream 'hx'.

        if ! grep -q '^alias hx="helix"' ~/.bashrc 2>/dev/null; then
          echo 'alias hx="helix"' >>~/.bashrc
        fi
      '';
    })
  ];
}