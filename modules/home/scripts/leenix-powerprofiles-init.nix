{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-powerprofiles-init";

      text = ''
        #!/bin/bash

        # leenix:summary=Set the correct power profile on boot based on current AC/battery state.

        if leenix-battery-present && ! leenix-ac-present; then
          leenix-powerprofiles-set battery
        else
          leenix-powerprofiles-set ac
        fi
      '';
    })
  ];
}