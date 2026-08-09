{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-intel-ptl";

      runtimeInputs = with pkgs; [
        pciutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Detect whether the computer has an Intel Panther Lake GPU.

        lspci | grep -iE 'vga|3d|display' | grep -qi 'panther lake'
      '';
    })
  ];
}