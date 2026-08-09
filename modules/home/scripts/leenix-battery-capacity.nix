{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-battery-capacity";
      excludeShellChecks = [ "SC2046" ];

      runtimeInputs = with pkgs; [
        upower
        gnugrep
        gawk
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns the battery full capacity in Wh (rounded to whole number).

        battery_info=$(upower -i $(upower -e | grep BAT))

        echo "$battery_info" | awk '/energy-full:/ {
          printf "%d", $2
          exit
        }'
      '';
    })
  ];
}