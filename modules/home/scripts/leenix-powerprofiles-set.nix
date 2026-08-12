{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-powerprofiles-set";

      runtimeInputs = with pkgs; [
        power-profiles-daemon
        gawk
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set the power profile to the requested level, falling back to balanced

        # leenix:args=[autodetect|ac|battery|PROFILE]

        action="''${1-}"

        # Auto-detect when called with no argument: treat any Mains or USB

        # power-supply device reporting online=1 as "on AC". This handles

        # USB-C only laptops where the legacy AC device may not fire udev

        # events, and also avoids false negatives from per-port USB-C devices

        # that are present-but-empty (online=0) while another port supplies power.

        if [[ -z $action || $action == "autodetect" ]]; then
          action=battery
          for ps in /sys/class/power_supply/*; do
            [[ -r $ps/online && -r $ps/type ]] || continue
            type=$(cat "$ps/type")
            [[ $type == "Mains" || $type == "USB" ]] || continue
            if [[ $(cat "$ps/online") == "1" ]]; then
              action=ac
              break
            fi
          done
        fi

        if ! output=$(powerprofilesctl list 2>&1); then
          echo "error: $output" >&2
          exit 1
        fi

        mapfile -t profiles < <(printf '%s\n' "$output" | awk '/^\s*[\* ]\s*[a-zA-Z0-9-]+:$/ { gsub(/^[*[:space:]]+|:$/,""); print }')

        case "$action" in
          ac)
            # Prefer performance, fall back to balanced
            if [[ " ''${profiles[*]} " == *" performance "* ]]; then
              powerprofilesctl set performance
            else
              powerprofilesctl set balanced
            fi
            ;;
          battery)
            powerprofilesctl set balanced
            ;;
          *)
            # Explicit profile name: only set it when the profile is actually
            # available, never silently fall back to another profile.
            if [[ " ''${profiles[*]} " == *" $action "* ]]; then
              powerprofilesctl set "$action"
            else
              echo "error: power profile '$action' is not available (available: ''${profiles[*]:-none})" >&2
              exit 1
            fi
            ;;
        esac
      '';
    })
  ];
}