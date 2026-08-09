{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-system-lock";

      runtimeInputs = with pkgs; [
        procps
        hyprland
        hyprlock
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Lock the computer and turn off the display

        # leenix:group=system

        # leenix:name=lock

        # leenix:examples=leenix system lock

        if ! pidof hyprlock >/dev/null; then
          (
            hyprlock
            leenix-system-wake
          ) &
        fi

        # Set keyboard layout to default (first layout)

        hyprctl switchxkblayout all 0 > /dev/null 2>&1

        # Ensure 1password is locked

        if pgrep -x "1password" >/dev/null; then
          1password --lock &
        fi

        # Avoid running screensaver when locked

        pkill -f org.leenix.screensaver

        if [[ ''${LEENIX_LOCK_ONLY:-false} != "true" ]]; then
          (
            sleep 3
            pidof hyprlock >/dev/null || exit 0
            leenix-brightness-keyboard off
            leenix-brightness-display off
          ) &
        fi
      '';
    })
  ];
}