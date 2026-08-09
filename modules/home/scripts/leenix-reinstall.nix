{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-reinstall";

      runtimeInputs = with pkgs; [
        gum
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reinstall Leenix packages and reset default configs

        # leenix:requires-sudo=true

        set -e

        # Attempt to reinstall all default Leenix packages and reset all the default configs.

        echo -e "This will reinstall all the default Leenix packages and reset all default configs.\nWarning: All user changes to configs will be lost.\n"

        if gum confirm "Are you sure you want to reinstall and lose all config changes?"; then
          leenix-reinstall-git
          leenix-reinstall-pkgs
          leenix-reinstall-configs

          gum confirm "System has been reinstalled. Reboot?" && leenix-system-reboot
        fi
      '';
    })
  ];
}