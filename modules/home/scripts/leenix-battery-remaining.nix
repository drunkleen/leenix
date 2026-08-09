{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-battery-remaining";
      excludeShellChecks = [ "SC2046" ];

      runtimeInputs = with pkgs; [
        upower
        gnugrep
        gawk
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns the battery percentage remaining as an integer.

        upower -i $(upower -e | grep BAT) | awk '/percentage/ {
          print int($2)
          exit
        }'
      '';
    })
  ];
}