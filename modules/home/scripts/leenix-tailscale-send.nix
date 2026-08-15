{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-tailscale-send";

      runtimeInputs = with pkgs; [
        tailscale
        jq
        coreutils
        findutils
        walker
        zenity
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Send a file to a Tailscale peer via `tailscale file cp`

        # leenix:args=[path]

        # Uses the pinned tailscale CLI (`tailscale file cp <file> <target>:`).
        # Self is excluded; offline peers without file-cp support are skipped.

        set -euo pipefail

        json=$(tailscale status --json 2>/dev/null || { echo "Tailscale is not running" >&2; exit 1; })

        running=$(echo "$json" | jq -r '.BackendState')
        [[ $running == "Running" ]] || { echo "Tailscale is not connected (state: $running)" >&2; exit 1; }

        self=$(echo "$json" | jq -r '.Self.DNSName // empty')
        self=''${self%.}

        # Peers that are online and support file transfer
        mapfile -t targets < <(echo "$json" | jq -r --arg self "$self" '
          [.Peer[] | select(.DNSName | startswith($self) | not) | select(.Online == true)] | .[]
          | [.DNSName, (.TailscaleIPs[0] // "")] | @tsv')

        [[ ''${#targets[@]} -gt 0 ]] || { echo "No online peers available for file transfer" >&2; exit 1; }

        if [[ -n ''${1:-} ]]; then
          FILE="$1"
        else
          FILE=$(zenity --file-selection --title="Choose file to send" 2>/dev/null || leenix-menu-input "Full path to file")
        fi

        [[ -n $FILE && -f $FILE ]] || { echo "Invalid file: $FILE" >&2; exit 1; }

        # Walker selector over peers
        list=""
        for t in "''${targets[@]}"; do
          IFS=$'\t' read -r dns ip <<<"$t"
          list="$list\n󰮂  $ip"
        done

        selection=$(echo -e "$list" | leenix-launch-walker --dmenu --width 520 --prompt "Send to…" 2>/dev/null)
        [[ -n $selection ]] || exit 0

        # Match selection back to a target by host or ip
        chosen=""
        for t in "''${targets[@]}"; do
          IFS=$'\t' read -r dns ip <<<"$t"
          if [[ $selection == *"$ip"* ]]; then
            chosen="$dns"
            break
          fi
        done
        [[ -n $chosen ]] || { echo "Selection did not match a peer" >&2; exit 1; }

        tailscale file cp "$FILE" "$chosen:"
        echo "Sent $FILE to $chosen"
      '';
    })
  ];
}
