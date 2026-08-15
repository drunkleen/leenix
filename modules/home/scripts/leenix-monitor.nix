{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-monitor";
      excludeShellChecks = [ "SC2086" "SC2016" ];

      runtimeInputs = with pkgs; [
        hyprland
        jq
        coreutils
        gnused
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage monitor desired/effective state via HyprMon's hyprmon.lua

        # leenix:args=<list|status|desired|enable|disable|reconcile> [monitor]

        # Runtime monitor-layout owner is HyprMon's native persistent Lua
        # sidecar ~/.config/hypr/hyprmon.lua (loaded last by the Nix-generated
        # hyprland.lua; see modules/home/hyprland/hyprland.nix). This command
        # reads DESIRED state from that single file and applies it via the
        # Hyprland Lua API. Nix only owns the safe built-in default.
        #
        # State model:
        #   desired    - what the user chose, persisted in hyprmon.lua
        #   effective  - what Hyprland actually reports (hyprctl monitors all)
        #   safety     - a temporary runtime override that never rewrites
        #                hyprmon.lua (e.g. re-enabling the internal panel when
        #                every external display disappeared)

        set -euo pipefail

        HYPRMON_LUA="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprmon.lua"
        SAFETY_FILE="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/monitors/safety.leenix"

        # A connected output is "internal" when its connector name looks like a
        # laptop panel (eDP/LVDS/DSI). Capability detection, never a hardcoded name.
        is_internal() {
          [[ $1 =~ ^(eDP|LVDS|DSI|DSIC|eDP)- ]]
        }

        monitors_all() {
          hyprctl monitors all -j 2>/dev/null
        }

        monitors_active() {
          hyprctl monitors -j 2>/dev/null
        }

        # Active (usable) non-internal monitors, excluding Hyprland's synthetic
        # FALLBACK output which is created only when every real monitor is off.
        usable_external_count() {
          local internal="$1"
          if [[ -z $internal ]]; then
            monitors_all | jq -r '[.[] | select(.name != "FALLBACK" and .disabled == false)] | length'
          else
            monitors_all | jq -r --arg i "$internal" '[.[] | select(.name != $i and .name != "FALLBACK" and .disabled == false)] | length'
          fi
        }

        is_active() {
          monitors_all | jq -e --arg m "$1" '.[] | select(.name == $m and .disabled == false)' >/dev/null 2>&1
        }

        # Desired state for a monitor is read from the HyprMon Lua sidecar:
        # a rule with `disabled = true` => desired disabled; any other rule or
        # no rule at all => desired enabled (Nix safe default applies).
        desired_state() {
          local mon="$1" line
          [[ -f $HYPRMON_LUA ]] || { echo enabled; return 0; }
          line=$(grep -F "output = \"$mon\"" "$HYPRMON_LUA" | head -1 || true)
          [[ -z $line ]] && { echo enabled; return 0; }
          if echo "$line" | grep -q "disabled = true"; then
            echo disabled
          else
            echo enabled
          fi
        }

        # Set desired state inside hyprmon.lua via the single canonical locked
        # writer (leenix-hyprmon-edit): flock + re-read under lock + smallest
        # transformation + atomic write. Prevents lost updates between LEENIX
        # writers and never rewrites unrelated HyprMon fields.
        set_desired() {
          leenix-hyprmon-edit set "$1" "$2"
        }

        apply() {
          local mon="$1" state="$2"
          hyprctl eval "hl.monitor({ output = \"$mon\", disabled = $state })" >/dev/null 2>&1
        }

        # Re-apply the desired state for every monitor rule found in hyprmon.lua
        # plus every physically-connected monitor (falling back to enabled).
        # A final safety pass guarantees the user is never left with zero
        # usable displays (safety overrides are runtime-only and never rewrite
        # hyprmon.lua).
        reconcile() {
          local internal="" mon desired ext active
          local -a connected=()
          mapfile -t connected < <(monitors_all | jq -r '.[] | select(.name != "FALLBACK") | .name')
          for mon in "''${connected[@]}"; do
            if is_internal "$mon"; then internal="$mon"; fi
          done

          # Safety override bookkeeping file (desired state never lives here).
          mkdir -p "$(dirname "$SAFETY_FILE")"

          # 1) Apply the desired state (HyprMon hyprmon.lua) to every output.
          #    `apply` takes the `disabled` field value: true=off, false=on.
          for mon in "''${connected[@]}"; do
            desired=$(desired_state "$mon")
            if [[ $desired == "disabled" ]]; then
              apply "$mon" true
            else
              apply "$mon" false
            fi
          done

          # 2) Safety invariant: at least one usable display must be active.
          active=$(monitors_active | jq -r '[.[] | select(.name != "FALLBACK")] | length')
          if [[ $active -lt 1 && ''${#connected[@]} -gt 0 ]]; then
            fallback="''${internal:-''${connected[0]}}"
            apply "$fallback" false
            printf '{"monitor":"%s","safety":true}\n' "$fallback" > "$SAFETY_FILE.tmp" && mv -f "$SAFETY_FILE.tmp" "$SAFETY_FILE"
          else
            # 3) A usable display exists again: clear any safety marker.
            rm -f "$SAFETY_FILE"
          fi
        }

        case "''${1:-}" in
          list)
            monitors_all | jq -r --arg fallback "FALLBACK" '.[] | select(.name != $fallback) | [.name, (.description // ""), .disabled, .width, .height, .refreshRate] | @tsv'
            ;;
          status)
            mon="''${2:-}"
            [[ -n $mon ]] || { echo "usage: leenix-monitor status <monitor>" >&2; exit 1; }
            eff="down"
            is_active "$mon" && eff="up"
            echo "monitor: $mon"
            echo "effective: $eff"
            echo "desired: $(desired_state "$mon")"
            if [[ -f $SAFETY_FILE ]]; then
              echo "safety-override: yes ($(jq -r '.monitor // "?"' "$SAFETY_FILE"))"
            else
              echo "safety-override: no"
            fi
            ;;
          desired)
            mon="''${2:-}"
            [[ -n $mon ]] || { echo "usage: leenix-monitor desired <monitor>" >&2; exit 1; }
            desired_state "$mon"
            ;;
          enable|disable)
            mon="''${2:-}"
            [[ -n $mon ]] || { echo "usage: leenix-monitor $1 <monitor>" >&2; exit 1; }
            # The output must be physically present (connected). `monitors all`
            # lists connected outputs regardless of their enabled state.
            monitors_all | jq -e --arg m "$mon" '.[] | select(.name == $m)' >/dev/null 2>&1 ||
              { notify-send -u critical "leenix-monitor" "Monitor $mon is not connected" 2>/dev/null; exit 1; }
            # `want` is the `disabled` field value: enable -> disabled=false,
            # disable -> disabled=true.
            if [[ $1 == enable ]]; then
              want="false"
            else
              want="true"
            fi
            if [[ $1 == disable ]]; then
              if is_internal "$mon"; then
                internal="$mon"
                ext=$(usable_external_count "$internal")
                if [[ $ext -lt 1 ]]; then
                  notify-send -u critical "leenix-monitor" "Refusing to disable the last usable display" 2>/dev/null
                  exit 1
                fi
              else
                # Refuse to leave a user with zero usable displays even when the
                # internal panel rule is desired-disabled.
                active=$(monitors_active | jq -r '[.[] | select(.name != "FALLBACK")] | length')
                if [[ $active -lt 2 ]]; then
                  notify-send -u critical "leenix-monitor" "Refusing to disable the last usable display" 2>/dev/null
                  exit 1
                fi
              fi
            fi
            # Persist desired state in the single HyprMon sidecar, then apply.
            set_desired "$mon" "$want"
            apply "$mon" "$want" || {
              notify-send -u critical "leenix-monitor" "Failed to apply monitor state for $mon" 2>/dev/null
              exit 1
            }
            if [[ $1 == disable ]]; then
              notify-send -u low "Monitor $mon" "Disabled" 2>/dev/null
            else
              notify-send -u low "Monitor $mon" "Enabled" 2>/dev/null
            fi
            ;;
          reconcile)
            reconcile
            ;;
          *)
            echo "usage: leenix-monitor <list|status|desired|enable|disable|reconcile> [monitor]" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
