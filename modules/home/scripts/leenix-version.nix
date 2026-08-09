{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-version";

      text = ''
        #!/bin/bash

        # leenix:summary=Print the installed Leenix version

        cat "$LEENIX_PATH/version"
      '';
    })
  ];
}