{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-notification-send";
      excludeShellChecks = [ "SC2001" ];

      runtimeInputs = with pkgs; [
        gnused
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Send a desktop notification with Leenix glyph and body spacing

        # leenix:args=  [description] [notify-send options]

        # leenix:examples=leenix notification send "󰔛" "Reminder" "5 minutes are up" -u critical

        set -euo pipefail

        if (($# < 2)); then
          echo "Usage: leenix-notification-send   [description] [notify-send options]"
          exit 1
        fi

        glyph=$1
        headline=$2
        description=''${3:-}
        shift 2

        if (($# > 0)) && [[ $1 != -* ]]; then
          shift
        else
          description=""
        fi

        summary="$glyph    $headline"

        if [[ -n $description ]]; then
          description=$(sed 's/^/      /' <<<"$description")
          notify-send "$@" "$summary" "$description"
        else
          notify-send "$@" "$summary"
        fi
      '';
    })
  ];
}