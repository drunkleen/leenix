{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-limine";
      excludeShellChecks = [ "SC2046" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Overwrite the user config for the Limine bootloader and rebuild it.

        # leenix:requires-sudo=true

        if [[ -f /boot/EFI/Linux/leenix_linux.efi ]] && [[ -f /boot/EFI/Linux/$(cat /etc/machine-id)_linux.efi ]]; then
          echo "Cleanup extra UKI"
          sudo rm -f /boot/EFI/Linux/$(cat /etc/machine-id)_linux.efi
        fi

        echo "Resetting limine config"

        sudo mv /boot/limine.conf /boot/limine.conf.bak

        sudo cp ~/.local/share/leenix/default/limine/limine.conf /boot/limine.conf

        sudo limine-update
        sudo limine-snapper-sync
      '';
    })
  ];
}