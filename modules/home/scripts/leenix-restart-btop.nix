{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-btop";

      runtimeInputs = with pkgs; [
        procps
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reload btop configuration (used by the Leenix theme switching).

        pkill -SIGUSR2 btop
      '';
    })
  ];
}