{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-monitor-watch";

      runtimeInputs = with pkgs; [
        socat
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Watch Hyprland monitor events and recover monitor toggles when a monitor is removed

        SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

        socat -U - "UNIX-CONNECT:$SOCKET" | while read -r event; do
          case "$event" in
            monitorremoved\>\>*|monitorremovedv2\>\>*)
              leenix-hyprland-monitor-internal recover
              leenix-hyprland-monitor-internal-mirror recover
              ;;
          esac
        done
      '';
    })
  ];
}