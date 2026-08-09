{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-framework16";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Detect whether the computer is a Framework Laptop 16.

        [[ $(cat /sys/class/dmi/id/sys_vendor 2>/dev/null) == "Framework" ]] &&
          leenix-hw-match "Laptop 16"
      '';
    })
  ];
}