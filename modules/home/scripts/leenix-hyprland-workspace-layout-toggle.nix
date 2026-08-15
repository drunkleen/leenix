{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-workspace-layout-toggle";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        hyprland
        jq
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Toggle the layout on the current active workspace between dwindle and scrolling

        # Hyprland 0.56 Lua: `hyprctl keyword` is disabled for Lua configs, so
        # the per-workspace layout is applied via the workspace_rule Lua API.

        ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
        CURRENT_LAYOUT=$(hyprctl activeworkspace -j | jq -r '.tiledLayout')

        case "$CURRENT_LAYOUT" in
          dwindle) NEW_LAYOUT=scrolling ;;
          *) NEW_LAYOUT=dwindle ;;
        esac

        hyprctl eval "hl.workspace_rule({ workspace = \"$ACTIVE_WORKSPACE\", layout = \"$NEW_LAYOUT\" })" >/dev/null 2>&1
        notify-send -u low "󱂬    Workspace layout set to $NEW_LAYOUT"
      '';
    })
  ];
}
