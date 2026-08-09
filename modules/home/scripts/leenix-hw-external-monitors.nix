{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-external-monitors";

      text = ''
        #!/bin/bash

        # leenix:summary=Returns true when an external monitor is physically connected.

        for status in /sys/class/drm/card*-*/status; do
          [[ "$status" == *-eDP-*/status ]] && continue
          [[ "$(<"$status")" == "connected" ]] && exit 0
        done
        exit 1
      '';
    })
  ];
}