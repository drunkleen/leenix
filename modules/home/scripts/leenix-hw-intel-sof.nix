{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-intel-sof";

      runtimeInputs = with pkgs; [
        pciutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Detect whether the computer has an Intel SOF-capable audio DSP.

        # Matches Intel audio controllers (PCI class Multimedia audio or Audio device)

        # present on Skylake-and-later platforms that use sof-audio-pci-intel-* drivers.

        lspci | grep -qiE '(Multimedia audio controller|Audio device).*Intel'
      '';
    })
  ];
}