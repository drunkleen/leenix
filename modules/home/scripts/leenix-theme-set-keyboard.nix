{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-set-keyboard";

      text = ''
        #!/bin/bash

        # leenix:summary=Apply the current theme keyboard color to supported keyboards

        # leenix:hidden=true

        leenix-theme-set-keyboard-asus-rog
        leenix-theme-set-keyboard-f16
      '';
    })
  ];
}