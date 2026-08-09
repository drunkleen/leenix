{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-swayosd-client";

      runtimeInputs = with pkgs; [
        swayosd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Wrapper for swayosd-client that targets the currently focused monitor.

        # leenix:args=<swayosd-client-args...>

        exec swayosd-client --monitor "$(leenix-hyprland-monitor-focused)" "$@"
      '';
    })
  ];
}