{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Derive the internal laptop panel's declarative geometry (mode/position/scale)
  # from the Nix-owned Hyprland monitor config. The monitor NAME itself is
  # detected at runtime; Nix stays the source of truth for geometry policy.
  monitors = config.wayland.windowManager.hyprland.settings.monitor or [ ];
  internal = lib.findFirst (m: m ? output && builtins.isString m.output && lib.hasPrefix "eDP" m.output) null monitors;
  lapMode = lib.optionalString (internal != null && internal ? mode) (toString internal.mode);
  lapPosition = lib.optionalString (internal != null && internal ? position) (toString internal.position);
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

      # DESIRED state (what the user chose) lives in
      #   ''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/hardware/laptop-monitor
      # and is never auto-removed by safety overrides.
      #
      # EFFECTIVE state (what is actually on) is derived from Hyprland.
      #
      # Safety rule: the internal panel is never disabled unless at least one
      # usable external monitor is active. On uncertainty -> panel ON.

      STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/hardware"
      STATE="$STATE_DIR/laptop-monitor"

      # Declarative geometry (from Nix monitor config); empty if not defined.
      LAPTOP_MODE='${lib.escapeShellArg lapMode}'
      LAPTOP_POSITION='${lib.escapeShellArg lapPosition}'
      LAPTOP_SCALE='${lib.escapeShellArg lapScale}'

      debug() {
        [[ -n ''${LEENIX_DEBUG:-} ]] && echo "leenix-monitor-laptop: $*" >&2 || true
      }

      write_state() {
        mkdir -p "$STATE_DIR"
        local tmp="$STATE.tmp"
        printf '%s\n' "$1" >"$tmp"
        mv "$tmp" "$STATE"
      }

      desired_state() {
        if [[ -f $STATE && $(cat "$STATE") == "disabled" ]]; then
          echo disabled
        else
          echo enabled
        fi
      }

      internal_monitor() {
        hyprctl monitors all -j 2>/dev/null | jq -r '.[] | select(.name | test("^eDP-")) | .name' | head -1
      }

      # Count enabled external (non-internal) monitors. Hyprland's synthetic
      # "FALLBACK" output (created when every real monitor is disabled) is not
      # a usable external display and must never satisfy the safety check.
      external_count() {
        local int="$1"
        hyprctl monitors -j 2>/dev/null | jq -r --arg int "$int" '[.[] | select(.name != $int and .name != "FALLBACK")] | length'
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

      apply_enable() {
        local int="$1" lua
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
        desired=$(desired_state)
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
        write_state enabled
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
        write_state disabled
        cmd_apply
      }

      cmd_toggle() {
        if [[ $(desired_state) == "disabled" ]]; then
          cmd_enable
        else
          cmd_disable
        fi
      }

      cmd_status() {
        local int desired ext effective safety
        int=$(internal_monitor)
        desired=$(desired_state)
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

  watchCmd = pkgs.writeShellApplication {
    name = "leenix-monitor-state-watch";

    runtimeInputs = with pkgs; [
      socat
      coreutils
      jq
      hyprland
    ];

    text = ''
      #!/bin/bash

      # leenix:summary=Watch Hyprland monitor events and re-apply the persistent laptop-monitor state.

      state_file() {
        echo "''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/hardware/laptop-monitor"
      }

      # True if the internal laptop panel is currently disabled.
      laptop_disabled() {
        hyprctl monitors all -j 2>/dev/null | jq -e '.[] | select(.name | test("^eDP-")) | select(.disabled == true)' >/dev/null 2>&1
      }

      # Re-apply state once at startup (also covers the graphical-session hook).
      "${lib.getExe laptopCmd}" apply

      instance=$(hyprctl instances -j 2>/dev/null | jq -r '.[0].instance')
      if [[ -z $instance || $instance == "null" ]]; then
        echo "leenix-monitor-state-watch: no Hyprland instance" >&2
        exit 1
      fi

      socket="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr/$instance/.socket2.sock"
      if [[ ! -S $socket ]]; then
        echo "leenix-monitor-state-watch: event socket not found: $socket" >&2
        exit 1
      fi

      echo "leenix-monitor-state-watch: watching $socket"

      last_apply=0
      socat -u "UNIX-CONNECT:$socket" - | while IFS= read -r line; do
        case "$line" in
          monitoradded*|monitorremoved*)
            # Extract the monitor name (plain ">>NAME" or v2 ">>ID,NAME,DESC").
            raw=''${line#*>>}
            if [[ $raw == *,* ]]; then
              name=''${raw#*,}
              name=''${name%%,*}
            else
              name=$raw
            fi
            # Ignore internal-panel events (avoids recursive/event loops).
            [[ $name == eDP-* ]] && continue
            now=$(date +%s%3N)
            (( now - last_apply >= 500 )) || continue
            last_apply=$now
            echo "leenix-monitor-state-watch: $line -> applying state"
            "${lib.getExe laptopCmd}" apply
            # Reconnect case: the external may still be activating when
            # monitoradded fires. If desired=disabled and the laptop is not yet
            # disabled, retry briefly (bounded, no long sleeps) so the saved
            # preference is re-applied once the external is usable.
            if [[ $line == monitoradded* && $(cat "$(state_file)") == "disabled" ]]; then
              for _ in 1 2 3 4 5 6; do
                laptop_disabled && break
                sleep 0.5
                "${lib.getExe laptopCmd}" apply
              done
            fi
            ;;
        esac
      done
    '';
  };
in
{
  home.packages = [
    laptopCmd
    watchCmd
  ];

  systemd.user.services.leenix-monitor-state-watch = {
    Unit = {
      Description = "LEENIX monitor hotplug state watcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe watchCmd}";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
