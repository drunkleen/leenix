{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-network-tailscale";
      excludeShellChecks = [ "SC2016" ];

      runtimeInputs = with pkgs; [
        tailscale
        jq
        coreutils
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage the Tailscale runtime state (status/up/down/ip/diagnostics)

        # leenix:args=<status|up|down|ip|diagnostics>

        set -euo pipefail

        json_state() {
          tailscale status --json 2>/dev/null || echo '{"BackendState":"Unknown"}'
        }

        case "''${1:-status}" in
          status)
            json=$(json_state)
            state=$(echo "$json" | jq -r '.BackendState // "Unknown"')
            echo "backend: $state"
            if [[ $state == "Running" ]]; then
              node=$(echo "$json" | jq -r '.Self.DNSName // ""' | sed 's/\.$//')
              ipv4=$(echo "$json" | jq -r '[.Self.TailscaleIPs[] | select(contains(":") | not)] | first // ""')
              ipv6=$(echo "$json" | jq -r '[.Self.TailscaleIPs[] | select(contains(":"))] | first // ""')
              online=$(echo "$json" | jq -r '[.Peer[] | select(.Online == true)] | length')
              [[ -n $node ]] && echo "node: $node"
              [[ -n $ipv4 ]] && echo "tailscale ipv4: $ipv4"
              [[ -n $ipv6 ]] && echo "tailscale ipv6: $ipv6"
              echo "online peers: $online"
            else
              echo "Tailscale is not connected; authenticate with 'leenix-network-tailscale up'"
            fi
            ;;
          up)
            if [[ $(json_state | jq -r '.BackendState // "Unknown"') == "Running" ]]; then
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
