{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-chromium";

      runtimeInputs = with pkgs; [
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Refresh the ~/.config/chromium-flags.conf file from the Leenix defaults.

        CONFIG_FILE="$HOME/.config/chromium-flags.conf"
        INSTALL_GOOGLE_ACCOUNTS=false

        # Check if google accounts were installed

        if [[ -f $CONFIG_FILE ]] && \
          grep -q -- "--oauth2-client-id" "$CONFIG_FILE" && \
          grep -q -- "--oauth2-client-secret" "$CONFIG_FILE"; then
          INSTALL_GOOGLE_ACCOUNTS=true
        fi

        # Refresh the Chromium configuration

        leenix-refresh-config chromium-flags.conf

        # Re-install Google accounts if previously configured

        if [[ $INSTALL_GOOGLE_ACCOUNTS == "true" ]]; then
          leenix-install-chromium-google-account
        fi
      '';
    })
  ];
}