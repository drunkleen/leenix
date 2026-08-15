{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-camera";
      excludeShellChecks = [ "SC2086" "SC2012" "SC2034" ];

      runtimeInputs = with pkgs; [
        coreutils
        v4l-utils
        jq
        procps
        gnused
        libnotify
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Discover cameras and manage real camera privacy state (with preview/viewer)

        # leenix:args=<list|status|enable|disable|preview|viewer|apply> [camera]

        # Privacy model (default desired state: disabled):
        #   DECLARATIVE  - Nix installs a udev rule that deauthorizes ONLY the
        #                  USB video interfaces (bInterfaceClass 0x0E) at
        #                  device-ADD time
        #                  (modules/nixos/hardware/camera.nix,
        #                  variables.hardware.camera.privacy). A deauthorized
        #                  interface never binds a driver -> no /dev/video*.
        #                  Non-video interfaces (audio/IR/control) stay intact.
        #   RUNTIME      - `leenix-camera enable/disable` toggles `authorized`
        #                  on the SAME video interfaces via the privileged helper
        #                  leenix-camera-privileged (pkexec) for the CURRENT
        #                  session / device attachment. This is SESSION-SCOPED:
        #                  a replug or reboot re-runs the udev rule and privacy
        #                  is restored. The per-camera desired file records
        #                  intent, never effective state.
        #   EFFECTIVE    - a camera is effectively ENABLED only when a real
        #                  Video-Capture-capable /dev/videoN node exists and is
        #                  v4l2-queryable.
        #   DISCOVERY    - cameras are found from USB sysfs (video-class
        #                  interfaces) even when privacy has deauthorized them.
        #   PREVIEW      - resolves the camera's CAPTURE node and launches qv4l2
        #                  detached; never auto-enables a disabled camera.

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

        # Is this node a real Video Capture (or Multiplanar) node? Metadata-only
        # and output-only nodes are rejected via the reported Device Caps.
        is_capture_node() {
          local node="$1"
          v4l2-ctl -d "$node" --all 2>/dev/null | grep -q "Video Capture"
        }

        # First CAPTURE-capable /dev/videoN owned by the given USB device.
        capture_node_for_usb() {
          local usb="$1" v rp owner node
          for v in /sys/class/video4linux/video*/; do
            [[ -e "$v/device" ]] || continue
            rp=$(readlink -f "$v/device" 2>/dev/null)
            [[ -n $rp ]] || continue
            owner=$(usb_for_path "$rp" 2>/dev/null || true)
            [[ -n $owner && $owner == "$usb" ]] || continue
            node="/dev/$(basename "$v")"
            if is_capture_node "$node"; then
              echo "$node"
              return 0
            fi
          done
          return 1
        }

        node_for_usb() {
          capture_node_for_usb "$1"
        }

        # Effective state: enabled only when a capture-capable node exists.
        effective_for_usb() {
          local usb="$1" node
          node=$(node_for_usb "$usb")
          if [[ -n $node && -e $node ]]; then
            echo "on"
          else
            echo "off"
          fi
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

        # Every USB video interface (bInterfaceClass 0x0E) of a camera device.
        video_interfaces_for_usb() {
          local usb="$1" dev i
          dev=$(basename "$usb")
          for i in /sys/bus/usb/devices/"$dev":*/; do
            i=''${i%/}
            [[ -f "$i/bInterfaceClass" ]] || continue
            if [[ $(cat "$i/bInterfaceClass") == "0e" ]]; then
              echo "$i"
            fi
          done
        }

        # Enumerate USB cameras: every USB device exposing a video-class
        # interface, with its first CAPTURE node (empty if none).
        # Output: <real-usb-path>\t<pure-product>\t<capture-node>\t<display-name>
        list_usb_cameras() {
          local -a usbs=() names=() nodes=()
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
            [[ -n $node ]] || node="-"
            usbs+=("$rp"); names+=("$name"); nodes+=("$node")
          done
          local n j
          for ((n = 0; n < ''${#names[@]}; n++)); do
            local count=0
            for ((j = 0; j < ''${#names[@]}; j++)); do
              [[ ''${names[$j]} == "''${names[$n]}" ]] && count=$((count + 1))
            done
            local display="''${names[$n]}"
            if ((count > 1)); then
              display="''${names[$n]} (''${usbs[$n]##*/})"
            fi
            printf '%s\t%s\t%s\t%s\n' "''${usbs[$n]}" "''${names[$n]}" "''${nodes[$n]}" "$display"
          done
        }

        # Cameras that v4l2 knows about but we could not map to a USB device.
        list_v4l_only() {
          v4l2-ctl --list-devices 2>/dev/null | while IFS= read -r line; do
            if [[ $line != $'\t'* && -n $line ]]; then
              name="$line"
              IFS= read -r node || break
              node=$(echo "$node" | tr -d '\t' | tr ' ' '\n' | grep -E '^/dev/video[0-9]+$' | head -1)
              [[ -n $node ]] || continue
              usb=$(usb_for_node "$node" 2>/dev/null || true)
              [[ -n $usb ]] && continue
              printf '\t%s\t%s\t%s\n' "$name" "$node" "$name"
            fi
          done
        }

        # Resolve a camera target (display name, product, node, /dev/videoN or
        # USB path) to its row. Emits "usb\tname\tnode\tdisplay" on match.
        find_camera() {
          local target="$1" usb name node display
          while IFS=$'\t' read -r usb name node display; do
            if [[ $target == "$display" || $target == "$name" || $target == "$node" || ''${node#/dev/} == "$target" || $target == "$usb" ]]; then
              printf '%s\t%s\t%s\t%s\n' "$usb" "$name" "$node" "$display"
              return 0
            fi
          done < <(list_usb_cameras)
          return 1
        }

        cmd_list() {
          list_usb_cameras | while IFS=$'\t' read -r usb name node display; do
            if [[ $node == "-" ]]; then
              printf '%-14s  %s  (%s)\n' "--" "$display" "$(effective_for_usb "$usb")"
            else
              printf '%-14s  %s  (%s)\n' "$node" "$display" "$(effective_for_usb "$usb")"
            fi
          done
          list_v4l_only | while IFS=$'\t' read -r usb name node display; do
            printf '%-14s  %s  (on)\n' "$node" "$display"
          done
        }

        # Summary of the video interfaces of a camera.
        video_iface_state() {
          local usb="$1" i auths=0 total=0 driver="unbound"
          for i in $(video_interfaces_for_usb "$usb"); do
            total=$((total + 1))
            if [[ $(cat "$i/authorized" 2>/dev/null) == "1" ]]; then auths=$((auths + 1)); fi
            d=$(basename "$(readlink "$i/driver" 2>/dev/null)" 2>/dev/null || true)
            [[ -n $d ]] && driver="$d"
          done
          if [[ $total -eq 0 ]]; then
            echo "n/a"
          elif [[ $auths -eq $total ]]; then
            echo "1"
          elif [[ $auths -eq 0 ]]; then
            echo "0"
          else
            echo "partial"
          fi
          echo "$driver"
        }

        cmd_status() {
          local target="$1" row usb name node display
          row=$(find_camera "$target") || { echo "camera: $target not found" >&2; return 1; }
          IFS=$'\t' read -r usb name node display <<<"$row"

          local ifstate driver
          ifstate=$(video_iface_state "$usb")
          driver=$(echo "$ifstate" | tail -1)
          ifstate=$(echo "$ifstate" | head -1)

          printf 'camera: %s\n' "$display"
          printf 'desired: %s\n' "$(desired_for_usb "$usb")"
          printf 'effective: %s\n' "$(effective_for_usb "$usb")"
          printf 'usb-device-authorized: %s\n' "$(cat "$usb/authorized" 2>/dev/null || echo unknown)"
          printf 'video-interface-authorized: %s\n' "$ifstate"
          printf 'driver: %s\n' "$driver"
          if [[ $node == "-" ]]; then
            printf 'capture-node: none\n'
          else
            printf 'capture-node: %s\n' "$node"
          fi
          if grep -rqs 'ATTR{bInterfaceClass}=="0e"' /etc/udev/rules.d/ 2>/dev/null; then
            printf 'privacy-policy: enabled\n'
          else
            printf 'privacy-policy: disabled\n'
          fi
          printf 'policy: udev re-deauthorizes on replug/reboot (privacy default)\n'
        }

        # Call the privileged helper for every video interface of the camera.
        # IMPORTANT: pkexec must be the SETUID NixOS wrapper at
        # /run/wrappers/bin/pkexec. The polkit package's own pkexec is NOT
        # setuid and fails with "pkexec must be setuid root", so never let it
        # shadow the wrapper on PATH (polkit is NOT in this script's runtime
        # inputs).
        run_privileged() {
          local helper="$1" action="$2" bin=""
          shift 2
          if [[ -n ''${WAYLAND_DISPLAY:-} || -n ''${DISPLAY:-} ]]; then
            if [[ -x /run/wrappers/bin/pkexec ]]; then
              bin=/run/wrappers/bin/pkexec
            elif command -v pkexec >/dev/null 2>&1; then
              bin=$(command -v pkexec)
            fi
          fi
          if [[ -n $bin ]]; then
            "$bin" "$helper" "$action" "$@"
          else
            sudo "$helper" "$action" "$@"
          fi
        }

        privileged_ifaces() {
          local usb="$1" action="$2" helper
          helper=$(command -v leenix-camera-privileged 2>/dev/null || true)
          [[ -n $helper ]] || { echo "privileged camera helper not installed" >&2; return 1; }
          local -a ifaces=()
          mapfile -t ifaces < <(video_interfaces_for_usb "$usb")
          [[ ''${#ifaces[@]} -gt 0 ]] || { echo "no video interfaces found for camera" >&2; return 1; }
          run_privileged "$helper" "$action" "''${ifaces[@]}"
        }

        # Enable/disable a camera. Success is only reported when the EFFECTIVE
        # capture node appears (or disappears) and (for enable) is v4l2-queryable.
        cmd_toggle() {
          local action="$1" target="$2" row usb name node display
          [[ -n $target ]] || { echo "usage: leenix-camera $action <camera>" >&2; exit 1; }
          row=$(find_camera "$target") || { echo "camera '$target' not found" >&2; return 1; }
          IFS=$'\t' read -r usb name node display <<<"$row"

          if ! privileged_ifaces "$usb" "$action"; then
            echo "camera '$display': $action failed (privileged interface toggle rejected)" >&2
            notify-send -u critical "Camera $action failed" "Could not toggle '$display'. The authorization or sysfs write was rejected." 2>/dev/null
            return 1
          fi

          local i
          if [[ $action == "enable" ]]; then
            for ((i = 0; i < 12; i++)); do
              [[ -n $(node_for_usb "$usb" 2>/dev/null) ]] && break
              sleep 0.5
            done
            node=$(node_for_usb "$usb" 2>/dev/null || true)
            if [[ -z $node ]]; then
              echo "camera '$display': enable failed — no effective capture node appeared" >&2
              notify-send -u critical "Camera enable failed" "No capture node appeared for '$display' after re-authorization." 2>/dev/null
              return 1
            fi
            if ! v4l2-ctl -d "$node" --get-fmt-video >/dev/null 2>&1; then
              echo "camera '$display': enable failed — capture node not queryable" >&2
              notify-send -u critical "Camera enable failed" "Capture node $node is not v4l2-queryable for '$display'." 2>/dev/null
              return 1
            fi
            write_desired "$usb" enabled
            echo "camera '$display': enabled (effective: $(effective_for_usb "$usb"))"
            echo "NOTE: this grant is session/attachment-scoped; the declarative udev policy re-deauthorizes on replug/reboot." >&2
          else
            for ((i = 0; i < 8; i++)); do
              [[ -z $(node_for_usb "$usb" 2>/dev/null) ]] && break
              sleep 0.25
            done
            if [[ -n $(node_for_usb "$usb" 2>/dev/null) ]]; then
              echo "camera '$display': disable failed — effective capture node still present" >&2
              notify-send -u critical "Camera disable failed" "Capture node still present for '$display'." 2>/dev/null
              return 1
            fi
            write_desired "$usb" disabled
            echo "camera '$display': disabled (effective: $(effective_for_usb "$usb"))"
          fi
        }

        # Launch the qv4l2 viewer on a specific camera's capture node, detached.
        cmd_preview() {
          local target="$1" row usb name node display
          [[ -n $target ]] || { echo "usage: leenix-camera preview <camera>" >&2; exit 1; }
          row=$(find_camera "$target") || { echo "camera '$target' not found" >&2; return 1; }
          IFS=$'\t' read -r usb name node display <<<"$row"

          if [[ $node == "-" || ! -e $node ]]; then
            local auth
            auth=$(cat "$usb/authorized" 2>/dev/null || echo 1)
            if [[ $auth == "0" ]]; then
              notify-send -u critical "Camera '$display' is disabled by LEENIX privacy policy" \
                "Enable it first from: Toggles → Devices → Cameras → $display → Enable"
              echo "camera '$display': disabled by LEENIX privacy policy" >&2
            else
              notify-send -u critical "Camera '$display' has no usable capture node" \
                "The video interface is deauthorized. Enable it first from: Toggles → Devices → Cameras → $display → Enable"
              echo "camera '$display': no usable capture node" >&2
            fi
            return 1
          fi
          if ! command -v qv4l2 >/dev/null 2>&1; then
            notify-send -u critical "Camera preview unavailable" "qv4l2 (v4l-utils) is not installed"
            echo "camera '$display': qv4l2 not available" >&2
            return 1
          fi
          if ! v4l2-ctl -d "$node" --get-fmt-video >/dev/null 2>&1; then
            notify-send -u critical "Camera preview failed" "Could not open V4L2 node $node for '$display'"
            echo "camera '$display': V4L2 open failure on $node" >&2
            return 1
          fi
          setsid qv4l2 -d "$node" >/dev/null 2>&1 &
          echo "camera '$display': preview launched on $node"
        }

        # Open the general camera viewer on the first enabled camera.
        cmd_viewer() {
          local usb name node display
          while IFS=$'\t' read -r usb name node display; do
            if [[ $node != "-" && -e $node ]]; then
              setsid qv4l2 -d "$node" >/dev/null 2>&1 &
              echo "Open Camera Viewer: launching qv4l2 on $node"
              return 0
            fi
          done < <(list_usb_cameras)

          local hardware=0
          while IFS=$'\t' read -r usb name node display; do
            hardware=1
            break
          done < <(list_usb_cameras)
          if [[ $hardware -eq 1 ]]; then
            notify-send -u critical "No enabled camera available" \
              "Camera hardware exists but is disabled by LEENIX privacy policy. Enable one first from: Toggles → Devices → Cameras → <camera> → Enable"
            echo "no enabled camera (hardware present but disabled)" >&2
          else
            notify-send -u critical "No camera hardware found" "No V4L2 camera devices are present on this system"
            echo "no camera hardware found" >&2
          fi
          return 1
        }

        # Reapply desired state for cameras present right now (session start).
        cmd_apply() {
          local usb name node display desired i
          while IFS=$'\t' read -r usb name node display; do
            [[ -n $usb ]] || continue
            desired=$(desired_for_usb "$usb")
            if [[ $desired == "disabled" ]]; then
              for i in $(video_interfaces_for_usb "$usb"); do
                sudo -n sh -c "echo 0 > '$i/authorized'" 2>/dev/null || true
              done
            fi
          done < <(list_usb_cameras)
        }

        case "''${1:-list}" in
          list) cmd_list ;;
          status) cmd_status "''${2:-}" ;;
          enable) cmd_toggle enable "''${2:-}" ;;
          disable) cmd_toggle disable "''${2:-}" ;;
          preview) cmd_preview "''${2:-}" ;;
          viewer) cmd_viewer ;;
          apply) cmd_apply ;;
          *)
            echo "Usage: leenix-camera <list|status|enable|disable|preview|viewer|apply> [camera]" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
