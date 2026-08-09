{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-match";

      runtimeInputs = with pkgs; [
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Match against the computer's DMI product name or product family (case-insensitive).

        # leenix:args=

        grep -qi "$1" /sys/class/dmi/id/product_name 2>/dev/null ||
          grep -qi "$1" /sys/class/dmi/id/product_family 2>/dev/null
      '';
    })
  ];
}