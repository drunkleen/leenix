{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-font-list";

      runtimeInputs = with pkgs; [
        fontconfig
        gnugrep
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=List available monospace fonts

        # leenix:examples=leenix font list | leenix font set "CaskaydiaMono Nerd Font"

        fc-list :spacing=100 -f "%{family[0]}\n" | grep -v -i -E 'emoji|signwriting|leenix' | sort -u
      '';
    })
  ];
}