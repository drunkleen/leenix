{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-gaming-gpu-lib32";

      runtimeInputs = with pkgs; [
        pciutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install lib32 graphics drivers (Vulkan + NVIDIA) for any detected GPUs.

        # leenix:requires-sudo=true

        set -e

        echo "Installing lib32 graphics drivers..."

        PACKAGES=()

        declare -A VULKAN_DRIVERS=(
          [Intel]=lib32-vulkan-intel
          [AMD]=lib32-vulkan-radeon
        )
        for vendor in "''${!VULKAN_DRIVERS[@]}"; do
          if lspci | grep -iE "(VGA|Display).*$vendor" >/dev/null; then
            PACKAGES+=("''${VULKAN_DRIVERS[$vendor]}")
          fi
        done

        if leenix-hw-nvidia-gsp; then
          PACKAGES+=(lib32-nvidia-utils)
        elif leenix-hw-nvidia-without-gsp; then
          PACKAGES+=(lib32-nvidia-580xx-utils)
        fi

        [[ ''${#PACKAGES[@]} -gt 0 ]] && leenix-pkg-add "''${PACKAGES[@]}"
      '';
    })
  ];
}