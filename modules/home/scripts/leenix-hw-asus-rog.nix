{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-asus-rog";

      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Detect whether the computer is an Asus ROG machine.

        [[ $(cat /sys/class/dmi/id/sys_vendor 2>/dev/null) == "ASUSTeK COMPUTER INC." ]] &&
          grep -q "ROG" /sys/class/dmi/id/product_family 2>/dev/null
      '';
    })
  ];
}