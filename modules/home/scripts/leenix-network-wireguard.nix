{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-network-wireguard";

      runtimeInputs = with pkgs; [
        wireguard-tools
        systemd
        iproute2
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage declaratively-defined WireGuard interfaces (connect/disconnect/status)

        # leenix:args=<interface> <status|connect|disconnect>

        # Runtime control of the NixOS-generated wg-quick systemd units
        # (wireguard-<interface>.service, RemainAfterExit). The interface
        # configuration itself is declared in Nix; this script never authors
        # WireGuard config files.

        set -euo pipefail

        IFACE=''${1:-}
        ACTION=''${2:-status}

        if [[ -z $IFACE ]]; then
          echo "Usage: leenix-network-wireguard <interface> <status|connect|disconnect>" >&2
          exit 1
        fi

        case "$ACTION" in
          status)
            if systemctl is-active --quiet "wireguard-$IFACE.service"; then
              echo "interface $IFACE: up"
              wg show "$IFACE" 2>/dev/null || true
              exit 0
            fi
            echo "interface $IFACE: down"
            exit 1
            ;;
          connect)
            systemctl start "wireguard-$IFACE.service"
            echo "interface $IFACE: connected"
            ;;
          disconnect)
            systemctl stop "wireguard-$IFACE.service"
            echo "interface $IFACE: disconnected"
            ;;
          *)
            echo "Usage: leenix-network-wireguard <interface> <status|connect|disconnect>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
