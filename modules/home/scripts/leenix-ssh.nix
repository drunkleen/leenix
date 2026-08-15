{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-ssh";

      runtimeInputs = with pkgs; [
        systemd
        iproute2
        coreutils
        gnugrep
        openssh
        jq
        tailscale
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Show SSH runtime status and start/stop sshd (runtime only)

        # leenix:args=<status|start|stop>

        # Effective state always comes from systemd, never a state file.
        # Start/stop is runtime-only: declarative autoStart policy is untouched.

        set -uo pipefail

        case "''${1:-status}" in
          status)
            svc=$(systemctl is-active sshd 2>/dev/null || true)
            echo "Service: ''${svc:-unknown}"
            echo "Port: $(grep -E '^Port ' /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' | head -1 || true)"
            au=$(grep -E '^AllowUsers ' /etc/ssh/sshd_config 2>/dev/null | cut -d' ' -f2- | head -1 || true)
            echo "Allowed users: ''${au:-key-based (host policy)}"
            echo "LAN IPv4: $(ip -4 -o addr show scope global | awk '{print $4}' | grep -vE '^127\.' | paste -sd' ' - || true)"
            echo "LAN IPv6: $(ip -6 -o addr show scope global | awk '{print $4}' | grep -v '^::1' | paste -sd' ' - || true)"
            if command -v tailscale >/dev/null 2>&1 && tailscale status --json 2>/dev/null | jq -e '.BackendState == "Running"' >/dev/null 2>&1; then
              echo "Tailscale IPv4: $(tailscale ip -4 2>/dev/null || true)"
              echo "Tailscale IPv6: $(tailscale ip -6 2>/dev/null || true)"
            fi
            ;;
          start)
            if systemctl is-active --quiet sshd; then
              echo "sshd already running"
              exit 0
            fi
            systemctl start sshd
            echo "sshd started (autoStart policy unchanged)"
            ;;
          stop)
            if ! systemctl is-active --quiet sshd; then
              echo "sshd already stopped"
              exit 0
            fi
            systemctl stop sshd
            echo "sshd stopped (autoStart policy unchanged)"
            ;;
          *)
            echo "Usage: leenix-ssh <status|start|stop>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
