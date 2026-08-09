{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-toggle-suspend";

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle suspend availability in the system menu

        leenix-toggle \
          --enabled-notification "󰒲   Suspend removed from system menu" \
          --disabled-notification "󰒲   Suspend now available in system menu" \
          suspend-off
      '';
    })
  ];
}