{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-remove-gaming-xbox-cloud";

      text = ''
        #!/bin/bash

        # leenix:summary=Remove the Xbox Cloud Gaming web app.

        set -e

        leenix-webapp-remove "Xbox Cloud Gaming"
      '';
    })
  ];
}