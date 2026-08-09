{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update";

      runtimeInputs = with pkgs; [
        coreutils
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Update Leenix and system packages

        # leenix:args=[-y]

        # leenix:examples=leenix update | leenix update -y

        # leenix:requires-sudo=true

        set -e

        # Run the update inside a PTY so pacman/yay keep showing download progress
        # while still logging the full session for later analysis.

        if [[ -z $LEENIX_UPDATE_LOGGED ]]; then
          script_command=$(printf '%q ' "$0" "$@")
          exec env LEENIX_UPDATE_LOGGED=1 script -qefc "$script_command" "/tmp/leenix-update.log"
        fi

        trap 'echo ""; echo -e "\033[0;31mSomething went wrong during the update!\n\nPlease review the output above carefully, correct the error, and retry the update.\n\nIf you need assistance, get help from the community at https://leenix.org/discord\033[0m"' ERR

        if [[ $1 == "-y" ]] || leenix-update-confirm; then
          leenix-snapshot create || (($? == 127))
          leenix-update-git
          leenix-update-perform
        fi
      '';
    })
  ];
}