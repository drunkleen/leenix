{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-walker";
      excludeShellChecks = [ "SC2086" "SC2231" ];

      runtimeInputs = with pkgs; [
        coreutils
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user configs for the Walker application launcher (which also powers the Leenix Menu) and restart the services.

        mkdir -p ~/.config/autostart/
        cp $LEENIX_PATH/default/walker/walker.desktop ~/.config/autostart/

        # And restarts if it crashes or is killed

        mkdir -p ~/.config/systemd/user/app-walker@autostart.service.d/
        cp $LEENIX_PATH/default/walker/restart.conf ~/.config/systemd/user/app-walker@autostart.service.d/restart.conf

        systemctl --user daemon-reload

        # Refresh configs

        leenix-refresh-config walker/config.toml
        leenix-refresh-config elephant/calc.toml
        leenix-refresh-config elephant/desktopapplications.toml

        # Link all elephant menus

        mkdir -p ~/.config/elephant/menus
        for menu in $LEENIX_PATH/default/elephant/*.lua; do
          ln -snf "$menu" ~/.config/elephant/menus/"$(basename "$menu")"
        done

        # Restart service

        leenix-restart-walker
      '';
    })
  ];
}