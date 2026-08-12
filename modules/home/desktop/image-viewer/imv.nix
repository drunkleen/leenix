{ pkgs, ... }:

{
  home.packages = [
    pkgs.imv
    (pkgs.writeShellApplication {
      name = "leenix-launch-image";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default image viewer (imv).

        exec ${pkgs.uwsm}/bin/uwsm app -t scope -- ${pkgs.imv}/bin/imv "$@"
      '';
    })
  ];

}
