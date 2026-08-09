{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-analyze-logs";

      runtimeInputs = with pkgs; [
        gnugrep
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Check the update log for known failure conditions

        update_log="/tmp/leenix-update.log"

        # Check for initramfs generation failure

        if grep -q "Updating linux initcpios" "$update_log"; then
          if ! grep -q "Initcpio image generation successful" "$update_log"; then
            echo -e '\e[31mError: Initramfs generation may have failed. Review logs before restart.\e[0m'
            echo
          fi
        fi
      '';
    })
  ];
}