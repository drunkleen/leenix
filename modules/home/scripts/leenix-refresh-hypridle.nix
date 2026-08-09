{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-hypridle";

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user config for hypridle with the Leenix default and restart the service.

        leenix-refresh-config hypr/hypridle.conf
        leenix-restart-hypridle
      '';
    })
  ];
}