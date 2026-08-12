{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-dropbox";

      text = ''
        #!/bin/bash

        # leenix:summary=Install and start the Dropbox service. Must then be authenticated via the web.

        echo "Installing all dependencies..."
        leenix-pkg-add dropbox dropbox-cli libappindicator-gtk3 python-gpgme

        echo "Starting Dropbox..."
        uwsm-app -- dropbox-cli start &>/dev/null &
        echo "See Dropbox icon behind  hover tray in top right and right-click for setup."
      '';
    })
  ];
}