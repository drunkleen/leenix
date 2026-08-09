{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-asus-zenbook-ux5406aa";

      text = ''
        #!/bin/bash

        # leenix:summary=Detect ASUS Zenbook UX5406AA series laptops on Intel Panther Lake.

        leenix-hw-match "ux5406aa" && leenix-hw-intel-ptl
      '';
    })
  ];
}