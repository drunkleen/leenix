{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Derive the internal laptop panel's declarative geometry (mode/position/scale)
  # from the Nix-owned Hyprland monitor config. This is a fallback only: when
  # HyprMon's hyprmon.lua already holds a full rule for the internal panel that
  # rule wins (single monitor-layout owner). The monitor NAME is detected at
  # runtime; Nix stays the source of truth for the geometry policy.
  monitors = config.wayland.windowManager.hyprland.settings.monitor or [ ];
  internal = lib.findFirst (m: m ? output && builtins.isString m.output && lib.hasPrefix "eDP" m.output) null monitors;
  lapMode = lib.optionalString (internal != null && internal ? mode) (toString internal.mode);
  # Normalize the legacy hyprlang "0,0" position to the Lua API "0x0" format so
  # the fallback apply never hits hl.monitor's 'position' error.
  lapPositionRaw = lib.optionalString (internal != null && internal ? position) (toString internal.position);
  lapPosition = lib.replaceStrings [ "," ] [ "x" ] lapPositionRaw;
  lapScale = lib.optionalString (internal != null && internal ? scale) (toString internal.scale);

  laptopCmd = pkgs.writeShellApplication {
    name = "leenix-monitor-laptop";
    excludeShellChecks = [ "SC2086" ];

    runtimeInputs = with pkgs; [
      hyprland
      jq
      coreutils
      libnotify
    ];

    text = ''
      #!/bin/bash

      # leenix:summary=Enable/disable the internal laptop display with persistent desired state and zero-display safety.

      # leenix:args=<enable|disable|toggle|status|apply>

      # DESIRED state (what the user chose) is owned by HyprMon's hyprmon.lua
      # (~/.config/hypr/hyprmon.lua) — the single mutable monitor-layout file.
      # This command only reads that file and applies via the Hyprland Lua API.
      #
      # EFFECTIVE state (what is actually on) is derived from Hyprland.
      #
      # Safety rule: the internal panel is never disabled unless at least one
      # usable external monitor is active. On uncertainty -> panel ON. Safety
      # overrides are runtime-only and never rewrite hyprmon.lua.

      HYPRMON_LUA="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprmon.lua"

      # Declarative geometry (from Nix monitor config); empty if not defined.
      LAPTOP_MODE='${lib.escapeShellArg lapMode}'
      LAPTOP_POSITION='${lib.escapeShellArg lapPosition}'
      LAPTOP_SCALE='${lib.escapeShellArg lapScale}'

      debug() {
        [[ -n ''${LEENIX_DEBUG:-} ]] && echo "leenix-monitor-laptop: $*" >&2 || true
      }

      internal_monitor() {
        hyprctl monitors all -j 2>/dev/null | jq -r '.[] | select(.name | test("^(eDP|LVDS|DSI)-")) | .name' | head -1
      }

      # Desired state of the internal panel: from hyprmon.lua when a rule for
      # the panel exists (HyprMon owner), otherwise enabled (Nix safe default).
      desired_state() {
        local int="$1"
        [[ -n $int ]] || { echo enabled; return 0; }
        [[ -f $HYPRMON_LUA ]] || { echo enabled; return 0; }
        if grep -F "output = \"$int\"" "$HYPRMON_LUA" | grep -q "disabled = true"; then
          echo disabled
        else
          echo enabled
        fi
      }

      # Count enabled external (non-internal) monitors. Hyprland's synthetic
      # "FALLBACK" output (created when every real monitor is disabled) is not
      # a usable external display and must never satisfy the safety check.
      external_count() {
        local int="$1"
        if [[ -n $int ]]; then
          hyprctl monitors all -j 2>/dev/null | jq -r --arg int "$int" '[.[] | select(.name != $int and .name != "FALLBACK" and .disabled == false)] | length'
        else
          hyprctl monitors all -j 2>/dev/null | jq -r '[.[] | select(.name != "FALLBACK" and .disabled == false)] | length'
        fi
      }

      internal_effective() {
        local int="$1"
        [[ -n $int ]] || { echo enabled; return 0; }
        if hyprctl monitors all -j 2>/dev/null | jq -e --arg n "$int" '.[] | select(.name == $n and .disabled == true)' >/dev/null 2>&1; then
          echo disabled
        else
          echo enabled
        fi
      }

      # Restore a full HyprMon rule verbatim when it exists; otherwise fall back
      # to the Nix-declared geometry (enabled).
      apply_enable() {
        local int="$1" line lua
        if [[ -f $HYPRMON_LUA ]]; then
          line=$(grep -F "output = \"$int\"" "$HYPRMON_LUA" | head -1 || true)
          if [[ -n $line ]] && [[ $line != *"disabled = true"* ]]; then
            hyprctl eval "$line" >/dev/null 2>&1
            return 0
          fi
        fi
        lua="hl.monitor({ output = \"$int\", disabled = false"
        [[ -n $LAPTOP_MODE ]] && lua="$lua, mode = \"$LAPTOP_MODE\""
        [[ -n $LAPTOP_POSITION ]] && lua="$lua, position = \"$LAPTOP_POSITION\""
        [[ -n $LAPTOP_SCALE ]] && lua="$lua, scale = $LAPTOP_SCALE"
        lua="$lua })"
        hyprctl eval "$lua" >/dev/null 2>&1
      }

      apply_disable() {
        local int="$1"
        hyprctl eval "hl.monitor({ output = \"$int\", disabled = true })" >/dev/null 2>&1
      }

      cmd_apply() {
        local int desired ext effective
        int=$(internal_monitor)
        [[ -n $int ]] || { debug "no internal monitor detected"; return 0; }
        desired=$(desired_state "$int")
        ext=$(external_count "$int")
        effective=$(internal_effective "$int")
        debug "desired=$desired internal=$int effective=$effective external=$ext"
        if [[ $desired == "disabled" && $ext -gt 0 ]]; then
          apply_disable "$int"
        else
          # desired=enabled, or desired=disabled with no external (safety) -> panel ON
          apply_enable "$int"
        fi
      }

      cmd_enable() {
        local int
        int=$(internal_monitor)
        [[ -n $int ]] || { debug "no internal monitor detected"; return 1; }
        # Prefer the canonical HyprMon-integrated command; fall back to a
        # direct Lua apply if leenix-monitor is not installed on this host.
        if command -v leenix-monitor >/dev/null 2>&1; then
          leenix-monitor enable "$int" 2>/dev/null || { apply_enable "$int"; }
        else
          apply_enable "$int"
        fi
        cmd_apply
      }

      cmd_disable() {
        local int ext
        int=$(internal_monitor)
        [[ -n $int ]] || { debug "no internal monitor detected"; return 1; }
        ext=$(external_count "$int")
        if [[ $ext -eq 0 ]]; then
          echo "Cannot disable laptop display: no external monitor is connected." >&2
          notify-send -u low "󰍹  Cannot disable laptop display: no external monitor is connected."
          return 1
        fi
        if command -v leenix-monitor >/dev/null 2>&1; then
          leenix-monitor disable "$int" 2>/dev/null || { apply_disable "$int"; }
        else
          apply_disable "$int"
        fi
        cmd_apply
      }

      cmd_toggle() {
        local int
        int=$(internal_monitor)
        if [[ $(desired_state "$int") == "disabled" ]]; then
          cmd_enable
        else
          cmd_disable
        fi
      }

      cmd_status() {
        local int desired ext effective safety
        int=$(internal_monitor)
        desired=$(desired_state "$int")
        ext=$(external_count "$int")
        effective=$(internal_effective "$int")
        safety=no
        [[ $desired == "disabled" && $effective == "enabled" ]] && safety=yes
        echo "desired: $desired"
        echo "internal: ''${int:-unknown}"
        echo "internal-effective: $effective"
        echo "external-connected: $ext"
        echo "safety-override: $safety"
      }

      case "''${1:-}" in
        enable) cmd_enable ;;
        disable) cmd_disable ;;
        toggle) cmd_toggle ;;
        status) cmd_status ;;
        apply) cmd_apply ;;
        *)
          echo "Usage: leenix-monitor-laptop {enable|disable|toggle|status|apply}" >&2
          exit 1
          ;;
      esac
    '';
  };
in
{
  home.packages = [
    laptopCmd
  ];
}
