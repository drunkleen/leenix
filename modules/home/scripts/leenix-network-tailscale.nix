{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-network-tailscale";

      runtimeInputs = with pkgs; [
        tailscale
        jq
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage the Tailscale runtime state (status/up/down/ip/diagnostics)

        # leenix:args=<status|up|down|ip|diagnostics>

        set -euo pipefail

        state() {
          tailscale status --json 2>/dev/null | jq -r '.BackendState // "Unknown"'
        }

        case "''${1:-status}" in
          status)
            if [[ $(state) == "Running" ]]; then
              tailscale status
            else
              echo "Tailscale is not connected (backend state: $(state))"
              exit 1
            fi
            ;;
          up)
            if [[ $(state) == "Running" ]]; then
              echo "Tailscale is already connected"
              exit 0
            fi
            tailscale up
            ;;
          down)
            tailscale down
            ;;
          ip)
            tailscale ip
            ;;
          diagnostics)
            tailscale netcheck
            ;;
          *)
            echo "Usage: leenix-network-tailscale <status|up|down|ip|diagnostics>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
