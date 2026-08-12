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

  # Canonical LEENIX ASCII logo, single source of truth. Consumed directly by
  # leenix-screensaver (TTE), leenix-show-logo and leenix-branding-screensaver.
  xdg.dataFile."leenix/logo.txt".text = ''
██      ███████ ███████ ███    ██ ██ ██   ██
██      ██      ██      ████   ██ ██  ██ ██
██      █████   █████   ██ ██  ██ ██   ███
██      ██      ██      ██  ██ ██ ██  ██ ██
███████ ███████ ███████ ██   ████ ██ ██   ██
  '';
}
