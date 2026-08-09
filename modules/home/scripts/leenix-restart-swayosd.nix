{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-swayosd";

      runtimeInputs = with pkgs; [
        systemd
        procps
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart the SwayOSD server

        systemctl --user daemon-reload
        systemctl --user stop swayosd-server.service || true
        pkill -x swayosd-server || true
        systemctl --user reset-failed swayosd-server.service || true
        systemctl --user enable --now swayosd-server.service
      '';
    })
  ];
}