{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-hypridle";

      text = ''
        #!/bin/bash

        # leenix:summary=Restart the hypridle service (used for idle detection and auto-lock).

        leenix-restart-app hypridle
      '';
    })
  ];
}