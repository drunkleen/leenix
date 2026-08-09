{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-battery-present";
      excludeShellChecks = [ "SC2086" ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns true if a battery is present on the system.

        for bat in /sys/class/power_supply/BAT*; do
          [[ -r $bat/present ]] &&
          [[ $(cat $bat/present) == "1" ]] &&
          [[ $(cat $bat/type) == "Battery" ]] &&
          exit 0
        done

        exit 1
      '';
    })
  ];
}