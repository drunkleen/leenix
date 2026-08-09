{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-first-run";

      runtimeInputs = with pkgs; [
        coreutils
        bash
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Finish the installation of Leenix with items that can only be done after logging in.

        # leenix:requires-sudo=true

        set -e

        FIRST_RUN_MODE=~/.local/state/leenix/first-run.mode

        if [[ -f $FIRST_RUN_MODE ]]; then
          rm -f "$FIRST_RUN_MODE"

          bash "$LEENIX_PATH/install/first-run/battery-monitor.sh"
          bash "$LEENIX_PATH/install/first-run/recover-internal-monitor.sh"
          bash "$LEENIX_PATH/install/first-run/cleanup-reboot-sudoers.sh"
          bash "$LEENIX_PATH/install/first-run/firewall.sh"
          bash "$LEENIX_PATH/install/first-run/dns-resolver.sh"
          bash "$LEENIX_PATH/install/first-run/gnome-theme.sh"
          bash "$LEENIX_PATH/install/first-run/swayosd.sh"
          bash "$LEENIX_PATH/install/first-run/gtk-primary-paste.sh"
          bash "$LEENIX_PATH/install/first-run/text-scaling.sh"
          bash "$LEENIX_PATH/install/first-run/elephant.sh"
          leenix-hook-install post-update "$LEENIX_PATH/install/first-run/install-voxtype.hook"
          sudo rm -f /etc/sudoers.d/first-run

          bash "$LEENIX_PATH/install/first-run/welcome.sh"
          bash "$LEENIX_PATH/install/first-run/wifi.sh"
        fi
      '';
    })
  ];
}