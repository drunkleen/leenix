{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-plymouth-reset";

      runtimeInputs = with pkgs; [
        findutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restore the default Leenix Plymouth boot theme and SDDM login screen

        # leenix:requires-sudo=true

        theme_dir="/usr/share/plymouth/themes/leenix"

        sudo find ~/.local/share/leenix/default/plymouth -maxdepth 1 -type f -exec cp -t "$theme_dir/" {} +
        sudo plymouth-set-default-theme leenix

        if leenix-cmd-present limine-mkinitcpio; then
          sudo limine-mkinitcpio
        else
          sudo mkinitcpio -P
        fi

        leenix-refresh-sddm
      '';
    })
  ];
}