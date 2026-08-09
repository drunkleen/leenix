{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-system-wake";

      text = ''
        #!/bin/bash

        # leenix:summary=Wake displays and restore brightness after idle

        # leenix:group=system

        # leenix:name=wake

        # leenix:examples=leenix system wake

        leenix-brightness-display on
        leenix-brightness-keyboard restore
      '';
    })
  ];
}