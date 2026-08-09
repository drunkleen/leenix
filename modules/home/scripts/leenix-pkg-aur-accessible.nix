{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-pkg-aur-accessible";

      runtimeInputs = with pkgs; [
        curl
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Returns true if the AUR is up and available.

        curl -sf --connect-timeout 30 --retry 3 --retry-delay 3 -A "leenix-update" \
          "https://aur.archlinux.org/rpc/?v=5&type=info&arg=base" >/dev/null
      '';
    })
  ];
}