{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-camera";
      excludeShellChecks = [ "SC2086" "SC2012" ];

      runtimeInputs = with pkgs; [
        coreutils
        v4l-utils
        jq
        polkit
        procps
        gnused
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Discover cameras and manage real camera privacy state

        # leenix:args=<list|status|enable|disable|apply> [name]

        # Privacy model (default desired state: disabled):
        #   DECLARATIVE  - Nix installs a udev rule that deauthorizes USB video
        #                  devices at device-add time
        #                  (modules/nixos/hardware/camera.nix,
        #                  variables.hardware.camera.privacy). This re-runs on
        #                  EVERY (re)plug and on boot, so privacy is always
        #                  restored after a camera re-enumerates.
        #   RUNTIME      - `leenix-camera enable/disable` writes the per-device
        #                  sysfs `authorized` attribute (via pkexec) for the
        #                  CURRENT session / device attachment. An `enable`
        #                  grant is SESSION-SCOPED: the next replug or reboot
        #                  re-runs the udev rule and deauthorizes the camera
        #                  again. The per-camera desired file records intent and
        #                  never claims effective state.
        #   EFFECTIVE    - a camera is effectively ENABLED only when a usable
        #                  /dev/videoN node exists for it; otherwise it is
        #                  effectively disabled (whether privacy-deauthorized or
        #                  present-but-unbound).
        #   DISCOVERY    - cameras are found from USB sysfs (video-class
        #                  interfaces) EVEN when the privacy rule has deauthorized
        #                  them and no /dev/video* exists, so the menu can offer
        #                  "Enable <camera>" instead of claiming "no cameras".

        set -uo pipefail

        ROOT="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix"
        STATE_DIR="$ROOT/hardware/cameras"

        # Normalized real path of a USB device (same namespace as readlink -f).
        usb_dev_is() {
          local p="$1"
          [[ -f "$p/idVendor" && -f "$p/authorized" ]]
        }

        # Walk up from a sysfs path (interface or v4l node) to the owning USB
        # device, echoing its REAL path.
        usb_for_path() {
          local p="$1"
          p=$(readlink -f "$p" 2>/dev/null)
          while [[ -n $p && $p != "/" ]]; do
            if usb_dev_is "$p"; then
              echo "$p"
              return 0
            fi
            p=''${p%/*}
          done
          return 1
        }

        # The USB device behind a /dev/videoN node ("" if not USB).
        usb_for_node() {
          local node="$1"
          [[ -e "/sys/class/video4linux/$(basename "$node")/device" ]] || return 1
          usb_for_path "/sys/class/video4linux/$(basename "$node")/device"
        }

        # Effective state: enabled only when a usable video node exists.
        effective_for_usb() {
          local usb="$1" node
          node=$(node_for_usb "$usb")
          if [[ -n $node && -e $node ]]; then
            echo "on"
          else
            echo "off"
          fi
        }

        # First usable /dev/videoN owned by the given USB device (real path).
        node_for_usb() {
          local usb="$1" v rp
          for v in /sys/class/video4linux/video*/; do
            [[ -e "$v/device" ]] || continue
            rp=$(readlink -f "$v/device" 2>/dev/null)
            if [[ -n $rp ]]; then
              local owner
              owner=$(usb_for_path "$rp" 2>/dev/null || true)
              if [[ -n $owner && $owner == "$usb" ]]; then
                echo "/dev/$(basename "$v")"
                return 0
              fi
            fi
          done
          return 1
        }

        # Desired state persisted per USB device path.
        desired_for_usb() {
          local usb="$1" f
          [[ -n $usb ]] || { echo "disabled"; return 0; }
          f="$STATE_DIR/$(echo "$usb" | tr '/' '_').leenix"
          if [[ -f $f && $(cat "$f") == "enabled" ]]; then echo "enabled"; else echo "disabled"; fi
        }

        write_desired() {
          local usb="$1" state="$2" f
          [[ -n $usb ]] || return 0
          mkdir -p "$STATE_DIR"
          f="$STATE_DIR/$(echo "$usb" | tr '/' '_').leenix"
          if [[ $state == "enabled" ]]; then
            printf '%s\n' "enabled" > "$f.tmp" && mv -f "$f.tmp" "$f"
          else
            rm -f "$f"
          fi
        }

        # Root write to a sysfs attribute. pkexec (polkit GUI) when a session is
        # available, otherwise sudo.
        write_sysfs() {
          local file="$1" value="$2"
          if command -v pkexec >/dev/null 2>&1 && [[ -n ''${WAYLAND_DISPLAY:-} || -n ''${DISPLAY:-} ]]; then
            pkexec sh -c "echo $value > '$file'" 2>/dev/null
          else
            sudo sh -c "echo $value > '$file'" 2>/dev/null
          fi
        }

        # Enumerate USB cameras: every USB device exposing a video-class
        # interface, with the first usable /dev/videoN (empty if none).
        # Output: <real-usb-path>\t<name>\t<node>
        list_usb_cameras() {
          local d name has_video i node rp
          for d in /sys/bus/usb/devices/[0-9]*/; do
            has_video=0
            for i in "$d"*:*/; do
              [[ -f "$i/bInterfaceClass" ]] || continue
              if [[ $(cat "$i/bInterfaceClass") == "0e" ]]; then has_video=1; break; fi
            done
            [[ $has_video -eq 1 ]] || continue
            rp=$(readlink -f "$d" 2>/dev/null)
            name=$(cat "$d/product" 2>/dev/null)
            [[ -n $name ]] || name=$(cat "$d/manufacturer" 2>/dev/null)
            [[ -n $name ]] || name="USB Video Device ($(cat "$d/idVendor" 2>/dev/null):$(cat "$d/idProduct" 2>/dev/null))"
            node=$(node_for_usb "$rp" 2>/dev/null || true)
            printf '%s\t%s\t%s\n' "$rp" "$name" "$node"
          done
        }

        # Cameras that v4l2 knows about but we could not map to a USB device
        # (rare); keep them visible so the list is complete.
        list_v4l_only() {
          v4l2-ctl --list-devices 2>/dev/null | while IFS= read -r line; do
            if [[ $line != $'\t'* && -n $line ]]; then
              name="$line"
              IFS= read -r node || break
              node=$(echo "$node" | tr -d '\t' | tr ' ' '\n' | grep -E '^/dev/video[0-9]+$' | head -1)
              [[ -n $node ]] || continue
              usb=$(usb_for_node "$node" 2>/dev/null || true)
              [[ -n $usb ]] && continue
              printf '\t%s\t%s\n' "$name" "$node"
            fi
          done
        }

        cmd_list() {
          list_usb_cameras | while IFS=$'\t' read -r usb name node; do
            printf '%-14s  %s  (%s)\n' "''${node:---}" "$name" "$(effective_for_usb "$usb")"
          done
          list_v4l_only | while IFS=$'\t' read -r usb name node; do
            printf '%-14s  %s  (on)\n' "$node" "$name"
          done
        }

        cmd_status() {
          local target="$1" found=0
          while IFS=$'\t' read -r usb name node; do
            if [[ $target == "$name" || $target == "$node" || ''${node#/dev/} == "$target" || $target == "$usb" ]]; then
              found=1
              printf 'camera: %s\n' "$name"
              printf 'node: %s\n' "''${node:-(none — privacy policy or driver not bound)}"
              printf 'effective: %s\n' "$(effective_for_usb "$usb")"
              printf 'desired: %s\n' "$(desired_for_usb "$usb")"
              if [[ -f "$usb/authorized" ]]; then
                if [[ $(cat "$usb/authorized") == "0" ]]; then
                  printf 'udev-privacy: deauthorized (declarative policy)\n'
                else
                  printf 'udev-privacy: authorized\n'
                fi
              fi
              printf 'policy: udev re-deauthorizes on replug/reboot (privacy default)\n'
              return 0
            fi
          done < <(list_usb_cameras)
          [[ $found -eq 1 ]] || { echo "camera: $target not found" >&2; return 1; }
        }

        # Toggle a camera by name, node, /dev/videoN or USB path.
        cmd_toggle() {
          local action="$1" target="$2" found=0 usb name node
          [[ -n $target ]] || { echo "usage: leenix-camera $action <camera>" >&2; exit 1; }
          while IFS=$'\t' read -r usb name node; do
            [[ $target == "$name" || $target == "$node" || ''${node#/dev/} == "$target" || $target == "$usb" ]] || continue
            found=1
            if [[ $action == "disable" ]]; then
              if ! write_sysfs "$usb/authorized" 0; then
                echo "camera '$name': failed to deauthorize (need polkit/sudo). Effective state unchanged." >&2
                return 1
              fi
              write_desired "$usb" disabled
              echo "camera '$name': disabled (effective: $(effective_for_usb "$usb"))"
            else
              # Ensure authorized=1. If no usable node appears, force a full
              # re-enumeration (0 -> 1) so uvcvideo binds and /dev/video exists.
              local auth
              auth=$(cat "$usb/authorized" 2>/dev/null || echo 0)
              if [[ $auth != "1" ]]; then
                write_sysfs "$usb/authorized" 1 || { echo "camera '$name': failed to authorize (need polkit/sudo)." >&2; return 1; }
              fi
              sleep 0.5
              if [[ -z $(node_for_usb "$usb" 2>/dev/null) ]]; then
                write_sysfs "$usb/authorized" 0 2>/dev/null || true
                sleep 0.3
                write_sysfs "$usb/authorized" 1 2>/dev/null || { echo "camera '$name': failed to re-authorize." >&2; return 1; }
                sleep 0.7
              fi
              write_desired "$usb" enabled
              echo "camera '$name': enabled (effective: $(effective_for_usb "$usb"))"
              echo "NOTE: this grant is session/attachment-scoped; the declarative udev policy re-deauthorizes on replug/reboot." >&2
            fi
          done < <(list_usb_cameras)
          [[ $found -eq 1 ]] || { echo "camera '$target' not found" >&2; return 1; }
        }

        # Reapply desired state for cameras present right now (session start).
        cmd_apply() {
          local usb name node desired
          while IFS=$'\t' read -r usb name node; do
            [[ -n $usb ]] || continue
            desired=$(desired_for_usb "$usb")
            if [[ $desired == "disabled" ]]; then
              # Session-start reapply prefers non-interactive best effort; the
              # declarative udev rule already covers a fresh boot.
              sudo -n sh -c "echo 0 > '$usb/authorized'" 2>/dev/null || true
            fi
          done < <(list_usb_cameras)
        }

        case "''${1:-list}" in
          list) cmd_list ;;
          status) cmd_status "''${2:-}" ;;
          enable) cmd_toggle enable "''${2:-}" ;;
          disable) cmd_toggle disable "''${2:-}" ;;
          apply) cmd_apply ;;
          *)
            echo "Usage: leenix-camera <list|status|enable|disable|apply> [camera]" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
