{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-swayosd";

      runtimeInputs = with pkgs; [
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart the declarative SwayOSD user service

        systemctl --user restart swayosd-server.service
      '';
    })
  ];
}