{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-asus-expertbook-b9406";

      text = ''
        #!/bin/bash

        # leenix:summary=Detect ASUS ExpertBook B9406 series laptops on Intel Panther Lake.

        leenix-hw-match "B9406" && leenix-hw-intel-ptl
      '';
    })
  ];
}