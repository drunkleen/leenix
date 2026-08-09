{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-brightness-keyboard-mute";

      runtimeInputs = with pkgs; [
        brightnessctl
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set the mic-mute indicator LED on laptops that expose a platform::micmute LED node.

        # leenix:args=<on|off>

        if [[ -e /sys/class/leds/platform::micmute/brightness ]]; then
          case "$1" in
            on)  value=1 ;;
            off) value=0 ;;
            *)   echo "Usage: $(basename "$0") <on|off>" >&2; exit 1 ;;
          esac

          brightnessctl --device="platform::micmute" set "$value" >/dev/null 2>&1 || true
        fi
      '';
    })
  ];
}