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

        # leenix:summary=Manage the Tailscale runtime state (status/up/down/ip/nodes/diagnostics)

        # leenix:args=<status|up|down|ip|nodes|diagnostics>

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
          nodes)
            json=$(tailscale status --json 2>/dev/null || true)
            if [[ -z $json || $(echo "$json" | jq -r '.BackendState // "Unknown"') != "Running" ]]; then
              echo "Tailscale is not connected; authenticate with 'leenix-network-tailscale up'"
              exit 0
            fi
            lastseen() {
              local ts=$1 now diff t
              if [[ -z $ts || $ts == "0001-01-01T00:00:00Z" ]]; then
                echo "-"
                return
              fi
              t=$(date -d "$ts" +%s 2>/dev/null) || { echo "-"; return; }
              now=$(date +%s)
              diff=$(( now - t ))
              if (( diff < 0 )); then
                echo "-"
              elif (( diff < 60 )); then
                echo "just now"
              elif (( diff < 3600 )); then
                echo "$(( diff / 60 ))m ago"
              elif (( diff < 86400 )); then
                echo "$(( diff / 3600 ))h ago"
              else
                echo "$(( diff / 86400 ))d ago"
              fi
            }
            printf '%-16s %-24s %-12s %-9s %s\n' "IP" "HOST" "USER" "OS" "STATUS"
            printf '%s\n' "───────────────────────────────────────────────────────────────────────────────"
            echo "$json" | jq -r '
              .User as $users |
              ((.Self | {ip: ([.TailscaleIPs[] | select(contains(":") | not)] | first // ""), host: (.DNSName | split(".")[0]), user: (($users[.UserID | tostring].LoginName // "") | split("@")[0]), os: .OS, online: .Online, last: "", self: "yes"})),
              (.Peer[] | {ip: ([.TailscaleIPs[] | select(contains(":") | not)] | first // ""), host: (.DNSName | split(".")[0]), user: (($users[.UserID | tostring].LoginName // "") | split("@")[0]), os: .OS, online: .Online, last: .LastSeen, self: "no"})
              | [.ip, .host, .user, .os, .online, .self, .last] | @tsv
            ' | while IFS=$'\t' read -r ip host user os online self last; do
              if [[ $online == "true" ]]; then
                status="connected"
                [[ $self == "yes" ]] && status="$status (this node)"
              else
                status="offline, last seen $(lastseen "$last")"
              fi
              printf '%-16s %-24s %-12s %-9s %s\n' "$ip" "$host" "$user" "$os" "$status"
            done
            ;;
          diagnostics)
            tailscale netcheck
            ;;
          *)
            echo "Usage: leenix-network-tailscale <status|up|down|ip|nodes|diagnostics>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
