{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-aur-pkgs";

      runtimeInputs = with pkgs; [
        pacman
        yay
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Update AUR packages if any are installed

        if pacman -Qem >/dev/null; then
          if leenix-pkg-aur-accessible; then
            echo -e "\e[32m\nUpdate AUR packages\e[0m"
            yay -Sua --noconfirm --cleanafter --ignore gcc14,gcc14-libs
            echo
          else
            echo -e "\e[31m\nAUR is unavailable (so skipping updates)\e[0m"
            echo
          fi
        fi
      '';
    })
  ];
}