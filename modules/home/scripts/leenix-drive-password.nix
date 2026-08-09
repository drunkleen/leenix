{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-drive-password";

      runtimeInputs = with pkgs; [
        util-linux
        coreutils
        cryptsetup
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set a new encryption password for a drive selected.

        # leenix:requires-sudo=true

        encrypted_drives=$(blkid -t TYPE=crypto_LUKS -o device)

        if [[ -n $encrypted_drives ]]; then
          if (( $(wc -l <<<"$encrypted_drives") == 1 )); then
            drive_to_change="$encrypted_drives"
          else
            drive_to_change="$(leenix-drive-select "$encrypted_drives")"
          fi

          if [[ -n $drive_to_change ]]; then
            echo "Changing full-disk encryption password for $drive_to_change"
            sudo cryptsetup luksChangeKey --pbkdf argon2id --iter-time 2000 "$drive_to_change"
          else
            echo "No drive selected."
          fi
        else
          echo "No encrypted drives available."
          exit 1
        fi
      '';
    })
  ];
}