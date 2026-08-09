{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-screensaver";

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle screensaver availability

        leenix-toggle \
          --enabled-notification "󱄄   Screensaver disabled" \
          --disabled-notification "󱄄   Screensaver enabled" \
          screensaver-off
      '';
    })
  ];
}