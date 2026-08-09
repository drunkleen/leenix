{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hibernation-available";

      runtimeInputs = with pkgs; [
        gawk
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Check if hibernation is supported

        if [[ ! -f /sys/power/image_size ]]; then
          exit 1
        fi

        # Sum all swap sizes (excluding zram)

        SWAPSIZE_KB=$(awk '!/Filename|zram/ {sum += $3} END {print sum+0}' /proc/swaps)
        SWAPSIZE=$(( 1024 * ''${SWAPSIZE_KB:-0} ))

        HIBERNATION_IMAGE_SIZE=$(cat /sys/power/image_size)

        if (( SWAPSIZE > HIBERNATION_IMAGE_SIZE )) && [[ -f /etc/mkinitcpio.conf.d/leenix_resume.conf ]]; then
          exit 0
        else
          exit 1
        fi
      '';
    })
  ];
}