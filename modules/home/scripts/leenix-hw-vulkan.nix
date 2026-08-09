{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-vulkan";

      runtimeInputs = with pkgs; [
        findutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Detect whether Vulkan is available.

        [[ -d /usr/share/vulkan/icd.d ]] &&
          find /usr/share/vulkan/icd.d -maxdepth 1 -name "*.json" -print -quit | grep -q .
      '';
    })
  ];
}