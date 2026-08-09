{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-wifi-powersave";

      runtimeInputs = with pkgs; [
        iw
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set Wi-Fi power save mode on wireless interfaces

        # leenix:args=<on|off>

        for iface in /sys/class/net/*/wireless; do
          iface="$(basename "$(dirname "$iface")")"
          iw dev "$iface" set power_save "$1" 2>/dev/null
        done
      '';
    })
  ];
}