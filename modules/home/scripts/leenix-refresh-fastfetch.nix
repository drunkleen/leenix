{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-fastfetch";

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user config for fastfetch with the Leenix default.

        leenix-refresh-config fastfetch/config.jsonc
      '';
    })
  ];
}