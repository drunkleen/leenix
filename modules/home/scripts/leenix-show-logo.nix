{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-show-logo";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Display the Leenix logo in the terminal using green color.

        clear
        echo -e "\033[32m"
        logo="''${XDG_DATA_HOME:-$HOME/.local/share}/leenix/logo.txt"
        cat < "$logo"
        echo -e "\033[0m"
        echo
      '';
    })
  ];

  xdg.dataFile."leenix/logo.txt".text = ''
    ██      ███████ ███████ ███    ██ ██ ██   ██
    ██      ██      ██      ████   ██ ██  ██ ██
    ██      █████   █████   ██ ██  ██ ██   ███
    ██      ██      ██      ██  ██ ██ ██  ██ ██
    ███████ ███████ ███████ ██   ████ ██ ██   ██
  '';
}
