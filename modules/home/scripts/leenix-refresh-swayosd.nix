{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-swayosd";

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user configs for swayosd (controls on-screen feedback for changing volume/songs etc) with the Leenix defaults and restart the service.

        leenix-refresh-config swayosd/config.toml
        leenix-refresh-config swayosd/style.css
        leenix-restart-swayosd
      '';
    })
  ];
}