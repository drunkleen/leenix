{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-chromium-google-account";

      runtimeInputs = with pkgs; [
        gnugrep
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Allow Chromium to sign in to Google accounts by adding the required OAuth credentials

        SECRET_FILE=~/.config/leenix/secrets/chromium-oauth-client-secret
        CHROMIUM_OAUTH_CLIENT_SECRET=''${CHROMIUM_OAUTH_CLIENT_SECRET:-}

        if [[ -z "$CHROMIUM_OAUTH_CLIENT_SECRET" && -f "$SECRET_FILE" ]]; then
          CHROMIUM_OAUTH_CLIENT_SECRET=$(head -n1 "$SECRET_FILE")
        fi

        if [[ -z "$CHROMIUM_OAUTH_CLIENT_SECRET" ]]; then
          echo "No Chromium OAuth client secret available."
          echo "Set CHROMIUM_OAUTH_CLIENT_SECRET or place it in $SECRET_FILE."
          exit 1
        fi

        if [[ -f ~/.config/chromium-flags.conf ]]; then
          echo "Installing Chromium Google account support..."
          CONF=~/.config/chromium-flags.conf

          grep -qxF -- "--oauth2-client-id=77185425430.apps.googleusercontent.com" "$CONF" ||
            echo "--oauth2-client-id=77185425430.apps.googleusercontent.com" >>"$CONF"

          grep -qxF -- "--oauth2-client-secret=$CHROMIUM_OAUTH_CLIENT_SECRET" "$CONF" ||
            echo "--oauth2-client-secret=$CHROMIUM_OAUTH_CLIENT_SECRET" >>"$CONF"

          echo "Now you can login to your Google Account in Chromium."
        fi
      '';
    })
  ];
}
