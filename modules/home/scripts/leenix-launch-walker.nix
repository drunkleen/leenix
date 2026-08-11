{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-walker";

      runtimeInputs = with pkgs; [
        coreutils
        systemd
        walker
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch Walker and ensure its service is running

        systemctl --user start walker.service

        exec walker --width 644 --maxheight 300 --minheight 300 "$@"
      '';
    })
  ];
}
