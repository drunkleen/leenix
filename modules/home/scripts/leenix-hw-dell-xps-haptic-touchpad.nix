{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-dell-xps-haptic-touchpad";

      text = ''
        #!/bin/bash

        # leenix:summary=Match Dell XPS systems with the Synaptics haptic touchpad.

        leenix-hw-match "XPS" && [[ -e /sys/bus/i2c/devices/i2c-VEN_06CB:00 ]]
      '';
    })
  ];
}