{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-system-shutdown";

      runtimeInputs = with pkgs; [
        bash
        coreutils
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Shut down after closing application windows

        # leenix:examples=leenix shutdown | leenix system shutdown

        # leenix:aliases=leenix shutdown

        leenix-state clear re*-required

        # Schedule the shutdown to happen after closing windows (detached from terminal)

        nohup bash -c "sleep 2 && systemctl poweroff --no-wall" >/dev/null 2>&1 &

        # Now close all windows

        leenix-hyprland-window-close-all
        sleep 1 # Allow apps like Chrome to shutdown correctly
      '';
    })
  ];
}