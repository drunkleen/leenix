{
  pkgs,
  variables,
  ...
}:

let
  laptopCap = variables.profiles.laptop or false;
  hyprlandCap = variables.desktop.hyprland or false;
  wifiCap = variables.networking.iwd or false;
  bluetoothCap = variables.hardware.bluetooth or false;
  wireguardIfaces = builtins.attrNames ((variables.networking or { }).wireguard.interfaces or { });
  openvpnProfiles = builtins.attrNames ((variables.networking or { }).openvpn.profiles or { });

  # Shell fragment defining the Nix-derived capability flags the menu branches
  # on. The menu only exposes branches for capabilities configured on the host.
  caps = ''
    LEENIX_CAP_LAPTOP=${
      if laptopCap then "1" else "0"
    }
    LEENIX_CAP_HYPRLAND=${
      if hyprlandCap then "1" else "0"
    }
    LEENIX_CAP_WIFI=${
      if wifiCap then "1" else "0"
    }
    LEENIX_CAP_BLUETOOTH=${
      if bluetoothCap then "1" else "0"
    }
    LEENIX_WG_IFACES=(${builtins.concatStringsSep " " (map (i: "'${i}'") wireguardIfaces)})
    LEENIX_OVPN_PROFILES=(${builtins.concatStringsSep " " (map (p: "'${p}'") openvpnProfiles)})
  '';
in

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu";
      excludeShellChecks = [ "SC1090" "SC2086" "SC2155" ];

      runtimeInputs = with pkgs; [
        bash
        coreutils
        findutils
        gnugrep
        gnused
        gawk
        procps
        util-linux
        jq
        gum
        walker
        hyprland
        systemd
        libnotify
        power-profiles-daemon
        iproute2
        wireguard-tools
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the Leenix Menu or jump straight to a submenu.

        ${caps}

        # Set to true when going directly to a submenu, so we can exit directly
        BACK_TO_EXIT=false

        back_to() {
          local parent_menu="$1"

          if [[ $BACK_TO_EXIT == "true" ]]; then
            exit 0
          elif [[ -n $parent_menu ]]; then
            "$parent_menu"
          else
            show_main_menu
          fi
        }

        toggle_existing_menu() {
          if pgrep -f "walker.*--dmenu" >/dev/null; then
            walker --close >/dev/null 2>&1
            exit 0
          fi
        }

        menu() {
          local prompt="$1"
          local options="$2"
          local extra=''${3:-}
          local preselect=''${4:-}

          read -r -a args <<<"$extra"

          if [[ -n $preselect ]]; then
            local index
            index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
            if [[ -n $index ]]; then
              args+=("-c" "$index")
            fi
          fi

          echo -e "$options" | leenix-launch-walker --dmenu --width 295 --minheight 1 --maxheight 630 -p "$prompt…" "''${args[@]}" 2>/dev/null
        }

        terminal() {
          xdg-terminal-exec --app-id=org.leenix.terminal "$@"
        }

        present_terminal() {
          leenix-launch-floating-terminal-with-presentation $1
        }

        # ---------------------------------------------------------------- Desktop
        show_desktop_menu() {
          local options="󰋼  Background\n󰆾  Screensaver\n  Capture\n󰓦  Toggles"
          case $(menu "Desktop" "$options") in
          *Background*) show_background_menu ;;
          *Screensaver*) leenix-launch-screensaver force ;;
          *Capture*) show_capture_menu ;;
          *Toggles*) show_toggle_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_background_menu() {
          case $(menu "Background" "󰋼  Choose Wallpaper\n󰁅  Next\n󰁈  Previous\n  Random\n󰉋  Open Folder\n  Refresh\n󰕮  Current") in
            *Choose*) leenix-wallpaper-switcher ;;
            *Next*) leenix-wallpaper-next ;;
            *Previous*) leenix-wallpaper-prev ;;
            *Random*) leenix-wallpaper-random ;;
            *Folder*) leenix-wallpaper-install ;;
            *Refresh*) leenix-wallpaper-refresh ;;
            *Current*) leenix-wallpaper-current ;;
            *) back_to show_desktop_menu ;;
          esac
        }

        show_capture_menu() {
          case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰴑  Text Extraction\n󰃉  Color") in
          *Screenshot*) leenix-capture-screenshot ;;
          *Screenrecord*) show_screenrecord_menu ;;
          *Text*) leenix-capture-text-extraction ;;
          *Color*) pkill hyprpicker || hyprpicker -a ;;
          *) back_to show_desktop_menu ;;
          esac
        }

        get_webcam_list() {
          v4l2-ctl --list-devices 2>/dev/null | while IFS= read -r line; do
            if [[ $line != $'\t'* && -n $line ]]; then
              local name="$line"
              IFS= read -r device || break
              device=$(echo "$device" | tr -d '\t' | head -1)
              [[ -n $device ]] && echo "$device  $name"
            fi
          done
        }

        show_webcam_select_menu() {
          local devices=$(get_webcam_list)
          local count=$(echo "$devices" | grep -c . 2>/dev/null || echo 0)

          if [[ -z $devices ]] || ((count == 0)); then
            notify-send "No webcam devices found" -u critical -t 3000
            return 1
          fi

          if ((count == 1)); then
            echo "$devices" | awk '{print $1}'
          else
            menu "Select Webcam" "$devices" | awk '{print $1}'
          fi
        }

        show_screenrecord_menu() {
          leenix-capture-screenrecording --stop-recording && exit 0

          case $(menu "Screenrecord" "  With no audio\n  With desktop audio\n  With desktop + microphone audio\n  With desktop + microphone audio + webcam") in
          *"With no audio") leenix-capture-screenrecording ;;
          *"With desktop audio") leenix-capture-screenrecording --with-desktop-audio ;;
          *"With desktop + microphone audio") leenix-capture-screenrecording --with-desktop-audio --with-microphone-audio ;;
          *"With desktop + microphone audio + webcam")
            local device=$(show_webcam_select_menu) || {
              back_to show_capture_menu
              return
            }
            leenix-capture-screenrecording --with-desktop-audio --with-microphone-audio --with-webcam --webcam-device="$device"
            ;;
          *) back_to show_capture_menu ;;
          esac
        }

        show_toggle_menu() {
          local options="󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰂛  Notifications\n󰍜  Top Bar\n󱂬  Workspace Layout\n  Window Gaps\n  1-Window Ratio\n󰍹  Monitor Scaling"

          case $(menu "Toggles" "$options") in
          *Screensaver*) leenix-toggle-screensaver ;;
          *Nightlight*) leenix-toggle-nightlight ;;
          *Idle*) leenix-toggle-idle ;;
          *Notifications*) leenix-toggle-notification-silencing ;;
          *Bar*) leenix-toggle-waybar ;;
          *Layout*) leenix-hyprland-workspace-layout-toggle ;;
          *Ratio*) leenix-hyprland-window-single-square-aspect-toggle ;;
          *Gaps*) leenix-hyprland-window-gaps-toggle ;;
          *Scaling*) leenix-hyprland-monitor-scaling-cycle ;;
          *) back_to show_desktop_menu ;;
          esac
        }

        # ---------------------------------------------------------------- Hardware
        show_hardware_menu() {
          local options="󰍹  Displays\n󰟸  Input\n󰍹  Audio"
          leenix-powerprofiles-list >/dev/null 2>&1 && options="$options\n󱐋  Power Profile"

          case $(menu "Hardware" "$options") in
          *Displays*) show_hardware_displays_menu ;;
          *Input*) show_hardware_input_menu ;;
          *Audio*) leenix-launch-audio ;;
          *Power*) show_setup_power_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_hardware_displays_menu() {
          local options=""
          if [[ $LEENIX_CAP_LAPTOP == "1" ]]; then
            local lap_action="Disable Laptop Monitor"
            [[ $(leenix-monitor-laptop status 2>/dev/null | sed -n 's/^desired: //p') == "disabled" ]] && lap_action="Enable Laptop Monitor"
            options="$options󰛧  $lap_action\n󰍹  Mirror Display"
          fi

          case $(menu "Displays" "$options") in
          *Disable*Laptop*) leenix-monitor-laptop disable ;;
          *Enable*Laptop*) leenix-monitor-laptop enable ;;
          *Mirror*) leenix-hyprland-monitor-internal-mirror toggle ;;
          *) back_to show_hardware_menu ;;
          esac
        }

        show_hardware_input_menu() {
          local options=""
          local tp_state tp_action ts_state ts_action

          if [[ $LEENIX_CAP_LAPTOP == "1" ]] && leenix-hw-touchpad; then
            tp_state=$(leenix-toggle-touchpad status | sed -n 's/^desired: //p')
            if [[ $tp_state == "disabled" ]]; then
              tp_action="Enable Touchpad"
            else
              tp_action="Disable Touchpad"
            fi
            options="$options󰟸  $tp_action"
          fi

          if [[ $LEENIX_CAP_LAPTOP == "1" ]] && leenix-hw-touchscreen; then
            ts_state=$(leenix-toggle-touchscreen status | sed -n 's/^desired: //p')
            if [[ $ts_state == "disabled" ]]; then
              ts_action="Enable Touchscreen"
            else
              ts_action="Disable Touchscreen"
            fi
            options="$options\n󰆽  $ts_action"
          fi

          if leenix-hw-dell-xps-haptic-touchpad && leenix-cmd-present dell-xps-touchpad-haptics; then
            options="$options\n󰌌  Touchpad Haptics"
          fi

          if leenix-hw-hybrid-gpu; then
            options="$options\n󰢮  Hybrid GPU"
          fi

          case $(menu "Input" "$options") in
          *Disable*Touchpad*) leenix-toggle-touchpad off ;;
          *Enable*Touchpad*) leenix-toggle-touchpad on ;;
          *Disable*Touchscreen*) leenix-toggle-touchscreen off ;;
          *Enable*Touchscreen*) leenix-toggle-touchscreen on ;;
          *Haptics*) show_hardware_touchpad_haptics_menu ;;
          *"Hybrid GPU"*) present_terminal leenix-toggle-hybrid-gpu ;;
          *) back_to show_hardware_menu ;;
          esac
        }

        show_hardware_touchpad_haptics_menu() {
          local current=$(dell-xps-touchpad-haptics get)
          local selected=$(menu "Touchpad Haptics" "low\nmid\nhigh" "" "$current")

          if [[ -n $selected ]]; then
            dell-xps-touchpad-haptics set "$selected"
          else
            back_to show_hardware_input_menu
          fi
        }

        # ---------------------------------------------------------------- Network
        show_network_menu() {
          local options="󰇫  DNS"

          if [[ $LEENIX_CAP_WIFI == "1" ]]; then
            options="$options\n  Wi-Fi"
          fi

          if [[ $LEENIX_CAP_BLUETOOTH == "1" ]]; then
            options="$options\n󰂯  Bluetooth"
          fi

          options="$options\n󰁾  Tailscale"

          if ((''${#LEENIX_WG_IFACES[@]} > 0)); then
            options="$options\n󰆗  WireGuard"
          fi

          if ((''${#LEENIX_OVPN_PROFILES[@]} > 0)); then
            options="$options\n󰈐  OpenVPN"
          fi

          case $(menu "Network" "$options") in
          *DNS*) leenix-config-dns ;;
          *Wi-Fi*) leenix-launch-wifi ;;
          *Bluetooth*) leenix-launch-bluetooth ;;
          *Tailscale*) show_tailscale_menu ;;
          *WireGuard*) show_wireguard_menu ;;
          *OpenVPN*) show_openvpn_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_tailscale_menu() {
          local action
          if tailscale status --json 2>/dev/null | jq -e '.BackendState == "Running"' >/dev/null; then
            action="󰁾  Disconnect"
          else
            action="󰁰  Connect"
          fi

          case $(menu "Tailscale" "󰵮  Status\n$action\n󰈀  IP / Node Info\n󰑬  Diagnostics") in
          *Status*) present_terminal "leenix-network-tailscale status" ;;
          *Disconnect*) leenix-network-tailscale down ;;
          *Connect*) present_terminal "leenix-network-tailscale up" ;;
          *"IP"*) present_terminal "leenix-network-tailscale ip" ;;
          *Diagnostics*) present_terminal "leenix-network-tailscale diagnostics" ;;
          *) back_to show_network_menu ;;
          esac
        }

        show_wireguard_menu() {
          local iface options=""
          for iface in "''${LEENIX_WG_IFACES[@]}"; do
            options="$options\n󰆗  $iface"
          done

          case $(menu "WireGuard" "$options") in
          *''${LEENIX_WG_IFACES[0]}*) show_wireguard_iface_menu "''${LEENIX_WG_IFACES[0]}" ;;
          *) back_to show_network_menu ;;
          esac
        }

        show_wireguard_iface_menu() {
          local iface="$1"
          local action
          if systemctl is-active --quiet "wireguard-$iface.service"; then
            action="󰁿  Disconnect"
          else
            action="󰁰  Connect"
          fi

          case $(menu "WireGuard: $iface" "󰵮  Status\n$action\n󰆗  Show All") in
          *Status*) present_terminal "leenix-network-wireguard $iface status" ;;
          *Disconnect*) leenix-network-wireguard "$iface" disconnect ;;
          *Connect*) leenix-network-wireguard "$iface" connect ;;
          *"Show All") present_terminal "wg show" ;;
          *) back_to show_wireguard_menu ;;
          esac
        }

        show_openvpn_menu() {
          local profile options=""
          for profile in "''${LEENIX_OVPN_PROFILES[@]}"; do
            options="$options\n󰈐  $profile"
          done

          case $(menu "OpenVPN" "$options") in
          *''${LEENIX_OVPN_PROFILES[0]}*) show_openvpn_profile_menu "''${LEENIX_OVPN_PROFILES[0]}" ;;
          *) back_to show_network_menu ;;
          esac
        }

        show_openvpn_profile_menu() {
          local profile="$1"
          local action
          if systemctl is-active --quiet "openvpn-$profile.service"; then
            action="󰁿  Disconnect"
          else
            action="󰁰  Connect"
          fi

          case $(menu "OpenVPN: $profile" "󰵮  Status\n$action") in
          *Status*) present_terminal "leenix-network-openvpn $profile status" ;;
          *Disconnect*) leenix-network-openvpn "$profile" disconnect ;;
          *Connect*) leenix-network-openvpn "$profile" connect ;;
          *) back_to show_openvpn_menu ;;
          esac
        }

        # ---------------------------------------------------------------- Locale
        show_locale_menu() {
          case $(menu "Locale" "󰧑  Language\n󰍛  Region & Formats\n󰥔  Timezone") in
          *Language*) leenix-config-language language ;;
          *Region*) leenix-config-language region ;;
          *Timezone*) leenix-config-timezone ;;
          *) back_to show_main_menu ;;
          esac
        }

        # ---------------------------------------------------------------- Tools
        show_tools_menu() {
          local options="󰔛  Reminder\n  Share\n󰧸  Transcode"
          case $(menu "Tools" "$options") in
          *Reminder*) show_reminder_menu ;;
          *Share*) show_share_menu ;;
          *Transcode*) leenix-transcode || back_to show_tools_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_reminder_menu() {
          case $(menu "Reminder" "󰔛  Set one\n󰔛  Show all\n󰔛  Clear all") in
          *Set*) show_custom_reminder_input ;;
          *"Show all"*) leenix-reminder show ;;
          *"Clear all"*) leenix-reminder clear ;;
          *) back_to show_tools_menu ;;
          esac
        }

        show_custom_reminder_input() {
          local minutes
          minutes=$(leenix-menu-input "Remind in minutes")

          if [[ $minutes =~ ^[0-9]+$ ]] && ((minutes > 0)); then
            show_reminder_message_input "$minutes"
          elif [[ -n $minutes ]]; then
            leenix-notification-send "󰔛" "Invalid reminder" "Enter the number of minutes" -u critical
            show_custom_reminder_input
          else
            back_to show_reminder_menu
          fi
        }

        show_reminder_message_input() {
          local minutes="$1"
          local message
          message=$(leenix-menu-input "Reminder message")

          if [[ -n $message ]]; then
            leenix-reminder "$minutes" "$message"
          else
            leenix-reminder "$minutes"
          fi
        }

        show_share_menu() {
          case $(menu "Share" "  Clipboard\n  File \n  Folder") in
          *Clipboard*) leenix-menu-share clipboard ;;
          *File*) terminal bash -c "leenix-menu-share file" ;;
          *Folder*) terminal bash -c "leenix-menu-share folder" ;;
          *) back_to show_tools_menu ;;
          esac
        }

        # ---------------------------------------------------------------- Setup
        show_setup_menu() {
          local options="󰒲  Sleep / Hibernate\n󰈷  Defaults"
          case $(menu "Setup" "$options") in
          *Sleep*) show_setup_system_menu ;;
          *Defaults*) show_setup_default_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_setup_system_menu() {
          local options=""
          if leenix-toggle-enabled suspend-off; then
            options="$options󰒲  Enable Suspend"
          else
            options="$options󰒲  Disable Suspend"
          fi

          if leenix-hibernation-available; then
            options="$options\n󰤁  Disable Hibernate"
          else
            options="$options\n󰤁  Enable Hibernate"
          fi

          case $(menu "Sleep / Hibernate" "$options") in
          *Suspend*) leenix-toggle-suspend ;;
          *"Enable Hibernate"*) present_terminal leenix-hibernation-setup ;;
          *"Disable Hibernate"*) present_terminal leenix-hibernation-remove ;;
          *) back_to show_setup_menu ;;
          esac
        }

        show_setup_default_menu() {
          case $(menu "Default" "  Terminal\n  Editor") in
          *Terminal*) show_setup_default_terminal_menu ;;
          *Editor*) show_setup_default_editor_menu ;;
          *) back_to show_setup_menu ;;
          esac
        }

        show_setup_default_terminal_menu() {
          local options=""
          leenix-cmd-present alacritty && options="$options  Alacritty"
          leenix-cmd-present foot && options="''${options:+$options\n}  Foot"
          leenix-cmd-present ghostty && options="''${options:+$options\n}  Ghostty"
          leenix-cmd-present kitty && options="''${options:+$options\n}  Kitty"

          local current=""
          case "$(leenix-default-terminal)" in
          alacritty) current="  Alacritty" ;;
          foot) current="  Foot" ;;
          ghostty) current="  Ghostty" ;;
          kitty) current="  Kitty" ;;
          esac

          case $(menu "Default Terminal" "$options" "" "$current") in
          *Alacritty*) leenix-default-terminal alacritty ;;
          *Foot*) leenix-default-terminal foot ;;
          *Ghostty*) leenix-default-terminal ghostty ;;
          *Kitty*) leenix-default-terminal kitty ;;
          *) back_to show_setup_default_menu ;;
          esac
        }

        show_setup_default_editor_menu() {
          local options=""
          leenix-cmd-present nvim && options="$options  Neovim"
          leenix-cmd-present code && options="''${options:+$options\n}  VSCode"
          leenix-cmd-present cursor && options="''${options:+$options\n}  Cursor"
          leenix-cmd-present zeditor && options="''${options:+$options\n}  Zed"
          leenix-cmd-present helix && options="''${options:+$options\n}  Helix"
          leenix-cmd-present vim && options="''${options:+$options\n}  Vim"
          leenix-cmd-present emacs && options="''${options:+$options\n}  Emacs"

          local current=""
          case "$(leenix-default-editor)" in
          nvim) current="  Neovim" ;;
          code) current="  VSCode" ;;
          cursor) current="  Cursor" ;;
          zed | zeditor) current="  Zed" ;;
          helix) current="  Helix" ;;
          vim) current="  Vim" ;;
          emacs) current="  Emacs" ;;
          esac

          case $(menu "Default Editor" "$options" "" "$current") in
          *Neovim*) leenix-default-editor nvim ;;
          *VSCode*) leenix-default-editor code ;;
          *Cursor*) leenix-default-editor cursor ;;
          *Zed*) leenix-default-editor zed ;;
          *Helix*) leenix-default-editor helix ;;
          *Vim*) leenix-default-editor vim ;;
          *Emacs*) leenix-default-editor emacs ;;
          *) back_to show_setup_default_menu ;;
          esac
        }

        show_setup_power_menu() {
          profile=$(menu "Power Profile" "$(leenix-powerprofiles-list)" "" "$(powerprofilesctl get)")

          if [[ $profile == "CNCLD" || -z $profile ]]; then
            back_to show_hardware_menu
          else
            powerprofilesctl set "$profile"
          fi
        }

        # ---------------------------------------------------------------- System
        show_system_menu() {
          local options="󰜉  Rebuild LEENIX\n󰤁  Hibernate"

          if [[ $LEENIX_CAP_HYPRLAND == "1" ]]; then
            options="$options\n  Lock"
          fi

          ! leenix-toggle-enabled suspend-off && options="$options\n󰒲  Suspend"
          options="$options\n󰍃  Logout\n󰜉  Restart\n󰐥  Shutdown"

          case $(menu "System" "$options") in
          *Rebuild*) present_terminal leenix-rebuild ;;
          *Hibernate*) systemctl hibernate ;;
          *Lock*) leenix-system-lock ;;
          *Suspend*) systemctl suspend ;;
          *Logout*) leenix-system-logout ;;
          *Restart*) leenix-system-reboot ;;
          *Shutdown*) leenix-system-shutdown ;;
          *) back_to show_main_menu ;;
          esac
        }

        # ---------------------------------------------------------------- Main
        show_main_menu() {
          go_to_menu "$(menu "Go" "󰀻  Desktop\n󰛧  Hardware\n󰇫  Network\n󰂻  Locale\n󰓦  Tools\n  Setup\n󰍉  About\n󰤆  System")"
        }

        go_to_menu() {
          case "''${1,,}" in
          *desktop*) show_desktop_menu ;;
          *hardware*) show_hardware_menu ;;
          *network*) show_network_menu ;;
          *locale*) show_locale_menu ;;
          *tools*) show_tools_menu ;;
          *setup*) show_setup_menu ;;
          *about*) leenix-launch-about ;;
          *system*) show_system_menu ;;
          esac
        }

        # Allow user extensions and overrides
        USER_EXTENSIONS="$HOME/.config/leenix/extensions/menu.sh"
        [[ -f $USER_EXTENSIONS ]] && source "$USER_EXTENSIONS"

        toggle_existing_menu

        if [[ -n ''${1:-} ]]; then
          BACK_TO_EXIT=true
          go_to_menu "$1"
        else
          show_main_menu
        fi
      '';
    })
  ];
}
