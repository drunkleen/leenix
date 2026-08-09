{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-refresh-hyprland";

      runtimeInputs = with pkgs; [
        bash
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Overwrite all the user configs in ~/.config/hypr with the Leenix defaults.

        leenix-refresh-config hypr/autostart.conf
        leenix-refresh-config hypr/bindings.conf
        leenix-refresh-config hypr/input.conf
        leenix-refresh-config hypr/looknfeel.conf
        leenix-refresh-config hypr/hyprland.conf
        leenix-refresh-config hypr/monitors.conf
        bash "$LEENIX_PATH/install/config/detect-keyboard-layout.sh"
      '';
    })
  ];
}