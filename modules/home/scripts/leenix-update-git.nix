{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-git";

      runtimeInputs = with pkgs; [
        git
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Pull the latest Leenix git changes

        set -e

        echo -e "\e[32mUpdate Leenix\e[0m"

        leenix-update-time

        # Suppress Hyprland config errors while git updates default config files mid-pull

        hyprctl keyword debug:suppress_errors true &>/dev/null || true

        git -C "$LEENIX_PATH" pull --autostash
        git -C "$LEENIX_PATH" --no-pager diff --check || git -C "$LEENIX_PATH" reset --merge

        hyprctl reload &>/dev/null || true
      '';
    })
  ];
}