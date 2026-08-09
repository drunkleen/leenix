{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-voxtype-install";

      runtimeInputs = with pkgs; [
        gum
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install and configure Voxtype dictation

        # leenix:requires-sudo=true

        set -e

        # Install voxtype and configure it for use.

        if gum confirm "Install Voxtype + AI model (~150MB) to enable dictation?"; then
          leenix-pkg-add wtype voxtype-bin

          # Setup voxtype

          mkdir -p "$HOME/.config/voxtype"
          cp "$LEENIX_PATH/default/voxtype/config.toml" \
            "$HOME/.config/voxtype/"

          voxtype setup --download --no-post-install

          if leenix-hw-vulkan; then
            voxtype setup gpu --enable || true
          fi

          voxtype setup systemd

          leenix-restart-waybar
          notify-send "    Voxtype Dictation Ready" \
            "Hold F9 to dictate (or toggle with Super + Ctrl + X)." \
            -t 10000
        fi
      '';
    })
  ];
}