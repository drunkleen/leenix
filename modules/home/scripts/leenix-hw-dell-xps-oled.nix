{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-dell-xps-oled";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Match Dell XPS systems with LG OLED panel on Intel Panther Lake (Xe3) GPU.

        leenix-hw-match "XPS" \
          && leenix-hw-intel-ptl \
          && test "$(od -An -tx1 -j8 -N2 /sys/class/drm/card*-eDP-*/edid 2>/dev/null | tr -d ' \n')" = "30e4"
      '';
    })
  ];
}