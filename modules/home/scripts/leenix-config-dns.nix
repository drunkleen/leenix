{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-config-dns";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Pick a DNS policy (system, preset, or custom) and apply it through the Nix configuration transaction.

        set -euo pipefail

        current=$(leenix-config get networking.dns 2>/dev/null || true)
        [[ -n $current ]] || current="system"

        opts=(
          "System / DHCP"
          "Cloudflare"
          "Quad9"
          "Google"
          "AdGuard"
          "Custom"
          "Show Current"
        )

        # Preselect the current mode.
        idx=""
        case "$current" in
          system) idx=1 ;;
          custom) idx=6 ;;
        esac
        args=()
        [[ -n $idx ]] && args+=("-c" "$idx")

        selected=$(leenix-menu-select "DNS" "''${opts[@]}" -- "''${args[@]}") || true
        [[ -n $selected ]] || exit 0

        case "$selected" in
          "System / DHCP")
            leenix-launch-floating-terminal-with-presentation leenix-config dns system
            ;;
          Cloudflare) leenix-launch-floating-terminal-with-presentation leenix-config dns preset cloudflare ;;
          Quad9) leenix-launch-floating-terminal-with-presentation leenix-config dns preset quad9 ;;
          Google) leenix-launch-floating-terminal-with-presentation leenix-config dns preset google ;;
          AdGuard) leenix-launch-floating-terminal-with-presentation leenix-config dns preset adguard ;;
          Custom)
            input=$(leenix-menu-input "DNS servers (space separated)") || true
            [[ -n $input ]] || exit 0
            # shellcheck disable=SC2206
            ips=($input)
            leenix-launch-floating-terminal-with-presentation leenix-config dns custom "''${ips[@]}"
            ;;
          "Show Current")
            leenix-launch-floating-terminal-with-presentation leenix-config dns show
            ;;
        esac
      '';
    })
  ];
}
