{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-hyprsunset";

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user config for hyprsunset with the Leenix default and restart the service.

        leenix-refresh-config hypr/hyprsunset.conf
        leenix-restart-hyprsunset
      '';
    })
  ];
}