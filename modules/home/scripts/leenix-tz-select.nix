{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-tz-select";

      runtimeInputs = with pkgs; [
        systemd
        gum
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Select and set the system timezone

        # leenix:requires-sudo=true

        timezone=$(timedatectl list-timezones | gum filter --height 20 --header "Set timezone") || exit 1
        sudo timedatectl set-timezone "$timezone"
        echo "Timezone is now set to $timezone"
        leenix-restart-waybar
      '';
    })
  ];
}