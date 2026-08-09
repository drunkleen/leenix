{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-nordvpn";

      runtimeInputs = with pkgs; [
        systemd
        shadow
        gum
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install the NordVPN service with optional GUI.

        # leenix:requires-sudo=true

        echo "Installing NordVPN..."
        leenix-pkg-aur-add nordvpn-bin

        echo "Enabling NordVPN daemon..."
        sudo systemctl enable --now nordvpnd

        echo "Adding user to nordvpn group..."
        sudo usermod -aG nordvpn "$USER"

        echo -e "\nNordVPN installed! After reboot, run 'nordvpn login' to authenticate."

        echo
        gum confirm "Reboot now to make NordVPN usable?" && leenix-system-reboot
      '';
    })
  ];
}