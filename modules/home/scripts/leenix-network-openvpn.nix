{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-network-openvpn";

      runtimeInputs = with pkgs; [
        systemd
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage declaratively-defined OpenVPN profiles (connect/disconnect/status)

        # leenix:args=<profile> <status|connect|disconnect>

        # Runtime control of the NixOS-generated openvpn-<profile>.service
        # units. Profile configuration (configs, credentials) is declared in
        # Nix; this script only manages the systemd service lifecycle.

        set -euo pipefail

        PROFILE=''${1:-}
        ACTION=''${2:-status}

        if [[ -z $PROFILE ]]; then
          echo "Usage: leenix-network-openvpn <profile> <status|connect|disconnect>" >&2
          exit 1
        fi

        case "$ACTION" in
          status)
            if systemctl is-active --quiet "openvpn-$PROFILE.service"; then
              echo "profile $PROFILE: connected"
              systemctl status "openvpn-$PROFILE.service" --no-pager | head -12
              exit 0
            fi
            echo "profile $PROFILE: disconnected"
            exit 1
            ;;
          connect)
            systemctl start "openvpn-$PROFILE.service"
            echo "profile $PROFILE: connected"
            ;;
          disconnect)
            systemctl stop "openvpn-$PROFILE.service"
            echo "profile $PROFILE: disconnected"
            ;;
          *)
            echo "Usage: leenix-network-openvpn <profile> <status|connect|disconnect>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
