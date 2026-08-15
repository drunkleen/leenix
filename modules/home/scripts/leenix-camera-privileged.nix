{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-camera-privileged";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Root helper for LEENIX camera privacy (enable/disable camera video interfaces)

        # leenix:args=<enable|disable> <usb-interface-path>...

        # leenix:hidden=true

        # Runs under pkexec (root). ONLY touches validated USB video-class
        # interfaces (bInterfaceClass 0x0E) of a discovered camera:
        #   enable  - authorize each video interface, then explicitly bind
        #             uvcvideo (authorizing alone does not re-probe the driver).
        #   disable - unbind uvcvideo, then deauthorize each video interface.
        # Inputs are strictly validated; no arbitrary sysfs writes are possible.

        set -euo pipefail

        if (( $# < 2 )); then
          echo "usage: leenix-camera-privileged <enable|disable> <interface-path>..." >&2
          exit 1
        fi

        action="$1"
        shift

        case "$action" in
          enable|disable) ;;
          *) echo "invalid action: $action" >&2; exit 1 ;;
        esac

        validate_iface() {
          local p="$1"
          if [[ ! $p =~ ^/sys/bus/usb/devices/[0-9a-fA-F-]+:[0-9]+\.[0-9]+$ ]]; then
            echo "invalid interface path: $p" >&2
            return 1
          fi
          [[ -f "$p/bInterfaceClass" ]] || { echo "not a USB interface: $p" >&2; return 1; }
          [[ $(cat "$p/bInterfaceClass") == "0e" ]] || { echo "not a video interface: $p" >&2; return 1; }
          [[ -w "$p/authorized" ]] || { echo "no writable authorized attribute: $p" >&2; return 1; }
          return 0
        }

        if [[ $action == "enable" ]]; then
          # 1) authorize every video interface
          for p in "$@"; do
            validate_iface "$p" || exit 1
            echo 1 > "$p/authorized"
          done
          # 2) explicitly bind uvcvideo (first successful bind claims the group)
          for p in "$@"; do
            name=$(basename "$p")
            echo "$name" > /sys/bus/usb/drivers/uvcvideo/bind 2>/dev/null || true
          done
        else
          # 1) unbind uvcvideo first
          for p in "$@"; do
            name=$(basename "$p")
            echo "$name" > /sys/bus/usb/drivers/uvcvideo/unbind 2>/dev/null || true
          done
          # 2) deauthorize every video interface
          for p in "$@"; do
            validate_iface "$p" || exit 1
            echo 0 > "$p/authorized"
          done
        fi
      '';
    })
  ];
}
