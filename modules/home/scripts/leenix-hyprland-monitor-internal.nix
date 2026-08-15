{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-monitor-internal";

      runtimeInputs = with pkgs; [
        hyprland
        jq
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Enable, disable, toggle, or recover the internal laptop display

        # leenix:args=<on|off|toggle|recover>

        # Thin wrapper around the canonical leenix-monitor-laptop command, which
        # owns the internal-panel desired state (via HyprMon's hyprmon.lua) and
        # the zero-display safety model.

        case "''${1:-}" in
          on) leenix-monitor-laptop enable ;;
          off) leenix-monitor-laptop disable ;;
          toggle) leenix-monitor-laptop toggle ;;
          recover) leenix-monitor-laptop apply ;;
          *)
            echo "Usage: $(basename "$0") {on|off|toggle|recover}" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
