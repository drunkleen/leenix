{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-font-current";

      runtimeInputs = with pkgs; [
        gnugrep
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Show current monospace font

        # leenix:examples=leenix font current

        grep -oP 'font-family:\s*["'\''']?\K[^;"'\''']+' ~/.config/waybar/style.css | head -n1
      '';
    })
  ];
}