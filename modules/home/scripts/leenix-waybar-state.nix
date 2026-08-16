{
  pkgs,
  variables,
  ...
}:

let
  waybarCfg = variables.desktop.waybar or { };
  capEnabled = waybarCfg.enable or false;
  defaultVisible = waybarCfg.defaultVisible or true;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-waybar-state";

      runtimeInputs = with pkgs; [
        coreutils
        systemd
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Resolve desired/default/effective Waybar visibility

        # leenix:args=

        # Canonical desired-state resolver for Waybar visibility. Desired state
        # is the persisted user preference (toggles/waybar) resolved against the
        # Nix-declared capability/default. Effective state is the real service
        # state. This script NEVER infers desired from the process — a crashed
        # Waybar must not silently convert desired=ON into OFF.

        # leenix-waybar-state depends on leenix-state (canonical helper).

        STATE_KEY="toggles/waybar"
        CAP_ENABLED=${if capEnabled then "1" else "0"}
        DEFAULT_VISIBLE=${if defaultVisible then "enabled" else "disabled"}

        resolve_desired() {
          if [[ $CAP_ENABLED != "1" ]]; then
            echo "disabled"
            return
          fi

          local v
          v=$(leenix-state get "$STATE_KEY" 2>/dev/null) || true

          if [[ $v == "enabled" || $v == "disabled" ]]; then
            echo "$v"
          elif [[ -z $v ]]; then
            echo "$DEFAULT_VISIBLE"
          else
            echo "invalid persisted waybar state '$v' on $STATE_KEY; falling back to default '$DEFAULT_VISIBLE'" >&2
            echo "$DEFAULT_VISIBLE"
          fi
        }

        effective_state() {
          if systemctl --user is-active --quiet waybar.service 2>/dev/null; then
            echo "running"
          else
            echo "stopped"
          fi
        }

        desired=$(resolve_desired)
        effective=$(effective_state)

        echo "desired: $desired"
        echo "default: $DEFAULT_VISIBLE"
        echo "effective: $effective"
      '';
    })
  ];
}
