{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-sddm";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Refresh the SDDM theme from default

        # leenix:requires-sudo=true

        sudo rm -rf /usr/share/sddm/themes/leenix
        sudo cp -r $LEENIX_PATH/default/sddm/leenix /usr/share/sddm/themes/leenix
      '';
    })
  ];
}