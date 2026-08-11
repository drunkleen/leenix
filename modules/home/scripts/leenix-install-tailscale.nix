{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-tailscale";

      runtimeInputs = with pkgs; [
        systemd
        tailscale
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install the Tailscale mesh VPN service.

        # leenix:requires-sudo=true

        echo -e "\nInstalling Tailscale..."
        leenix-pkg-add tailscale

        echo -e "\nStarting Tailscale..."
        sudo systemctl enable --now tailscaled.service
        sudo tailscale up --accept-routes
      '';
    })
  ];
}