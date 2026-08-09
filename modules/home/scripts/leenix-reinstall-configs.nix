{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-reinstall-configs";
      excludeShellChecks = [ "SC2086" "SC2091" ];

      runtimeInputs = with pkgs; [
        coreutils
        bash
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Reset all Leenix user configs to the defaults

        # leenix:requires-sudo=true

        set -e

        # Overwrite all user configs with the Leenix defaults.

        if (( EUID == 0 )); then
          echo "Error: This script should not be run as root"
          exit 1
        fi

        echo "Resetting all Leenix configs"
        cp -R ~/.local/share/leenix/config/* ~/.config/
        cp ~/.local/share/leenix/default/bashrc ~/.bashrc
        echo '[[ -f ~/.bashrc ]] && . ~/.bashrc' | tee ~/.bash_profile >/dev/null

        $(bash $LEENIX_PATH/install/config/theme.sh)

        leenix-refresh-limine
        leenix-refresh-plymouth
        leenix-nvim-setup
      '';
    })
  ];
}