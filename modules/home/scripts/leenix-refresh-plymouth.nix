{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-plymouth";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user config for the Plymouth drive decryption and boot sequence with the Leenix default and rebuild it.

        # leenix:requires-sudo=true

        sudo cp -r ~/.local/share/leenix/default/plymouth/* /usr/share/plymouth/themes/leenix/
        sudo plymouth-set-default-theme leenix

        if command -v limine-mkinitcpio &>/dev/null; then
          sudo limine-mkinitcpio
        else
          sudo mkinitcpio -P
        fi
      '';
    })
  ];
}