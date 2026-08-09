{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-hyprlock";

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user config for hyprlock with the Leenix default.

        leenix-refresh-config hypr/hyprlock.conf
      '';
    })
  ];
}