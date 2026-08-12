{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-powerprofiles-init";

      text = ''
        #!/bin/bash

        # leenix:summary=Select the normal LEENIX power profile at login (balanced when available).

        # Prefer the balanced profile when it is available, falling back to
        # power-saver, and otherwise keeping the current profile. Never forces
        # the performance profile and never fails startup.

        if leenix-powerprofiles-set balanced; then
          exit 0
        fi

        leenix-powerprofiles-set power-saver >/dev/null 2>&1 || true
        exit 0
      '';
    })
  ];
}