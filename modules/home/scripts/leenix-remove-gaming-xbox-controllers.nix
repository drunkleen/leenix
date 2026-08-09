{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-xbox-controllers";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Remove the xpadneo Xbox controller driver and undo its module/blacklist config.

        # leenix:requires-sudo=true

        set -e

        leenix-pkg-drop xpadneo-dkms

        sudo rm -f /etc/modprobe.d/blacklist-xpad.conf /etc/modules-load.d/xpadneo.conf

        echo ""
        echo "Xbox controller support removed. Reboot to fully unload xpadneo and restore xpad."
      '';
    })
  ];
}