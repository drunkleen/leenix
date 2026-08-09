{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-firmware";

      runtimeInputs = with pkgs; [
        coreutils
        fwupd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Update system firmware using fwupd. Ensures the fwupd EFI binary is installed

        # leenix:requires-sudo=true

        set -e

        echo -e "\e[32mUpdate Firmware\e[0m"

        if leenix-cmd-missing fwupdmgr; then
          leenix-pkg-add fwupd
        fi

        if [[ -d /sys/firmware/efi ]] && [[ -f /usr/lib/fwupd/efi/fwupdx64.efi ]]; then
          sudo install -D /usr/lib/fwupd/efi/fwupdx64.efi /boot/EFI/arch/fwupdx64.efi
        fi

        fwupdmgr refresh --force
        sudo fwupdmgr update
      '';
    })
  ];
}