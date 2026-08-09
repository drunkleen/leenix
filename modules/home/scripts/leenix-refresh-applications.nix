{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-applications";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
        gtk3
        desktop-file-utils
        bash
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Ensure all default .desktop, web apps, TUIs, and npx wrappers are installed.

        mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
        cp ~/.local/share/leenix/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/
        gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null

        # Copy .desktop declarations

        mkdir -p ~/.local/share/applications
        cp ~/.local/share/leenix/applications/*.desktop ~/.local/share/applications/
        cp ~/.local/share/leenix/applications/hidden/*.desktop ~/.local/share/applications/

        if leenix-cmd-present foot; then
          cp ~/.local/share/leenix/default/foot/foot.desktop ~/.local/share/applications/
        fi

        # Refresh the webapps, TUIs, and npx wrappers

        bash $LEENIX_PATH/install/packaging/icons.sh
        bash $LEENIX_PATH/install/packaging/webapps.sh
        bash $LEENIX_PATH/install/packaging/tuis.sh
        bash $LEENIX_PATH/install/packaging/npx.sh

        update-desktop-database ~/.local/share/applications
      '';
    })
  ];
}