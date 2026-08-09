{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-surface";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Detect whether the computer is a Microsoft Surface device.

        [[ $(cat /sys/class/dmi/id/sys_vendor 2>/dev/null) == "Microsoft Corporation" ]] &&
          leenix-hw-match "Surface"
      '';
    })
  ];
}