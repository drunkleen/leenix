{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-notification-dismiss";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        mako
        gnugrep
        coreutils
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Dismiss a mako notification on the basis of its summary. Used by the first-run notifications to dismiss them after clicking for action.

        # leenix:args=

        if (($# == 0)); then
          echo "Usage: leenix-notification-dismiss "
          exit 1
        fi

        # Find the first notification whose 'summary' matches the regex in $1

        notification_id=$(makoctl list | grep -F "$1" | head -n1 | sed -E 's/^Notification ([0-9]+):.*/\1/')

        if [[ -n $notification_id ]]; then
          makoctl dismiss -n $notification_id
        fi
      '';
    })
  ];
}