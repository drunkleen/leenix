{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-without-idle";

      text = ''
        #!/bin/bash

        # leenix:summary=No-op now that leenix-update-perform is responsible for idle management.

        # leenix:hidden=true
      '';
    })
  ];
}