{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-system-logout";

      runtimeInputs = with pkgs; [
        bash
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Log out after closing application windows

        # leenix:examples=leenix logout | leenix system logout

        # leenix:aliases=leenix logout

        nohup bash -c "sleep 2 && uwsm stop" >/dev/null 2>&1 &

        # Now close all windows

        leenix-hyprland-window-close-all
        sleep 1 # Allow apps like Chrome to shutdown correctly
      '';
    })
  ];
}