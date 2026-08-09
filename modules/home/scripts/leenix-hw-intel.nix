{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-intel";

      runtimeInputs = with pkgs; [
        gnugrep
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Detect whether the computer has an Intel CPU.

        [[ $(grep -m1 "vendor_id" /proc/cpuinfo 2>/dev/null | cut -d: -f2 | tr -d ' ') == "GenuineIntel" ]]
      '';
    })
  ];
}