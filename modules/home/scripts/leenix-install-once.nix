{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-once";

      runtimeInputs = with pkgs; [
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install the ONCE service, enable its background service, and launch the TUI.

        # leenix:requires-sudo=true

        echo "Installing ONCE..."
        leenix-pkg-add once-bin

        echo "Enabling ONCE background service..."
        sudo systemctl enable --now once-background.service

        echo -e "\nLaunching ONCE..."
        once
      '';
    })
  ];
}