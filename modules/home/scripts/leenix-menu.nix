{ pkgs, ... }:

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
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the Leenix Menu or takes a parameter to jump straight to a submenu.

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

        show_trigger_menu() {
          case $(menu "Trigger" "󰔛  Reminder\n  Capture\n󰧸  Transcode\n  Share\n󰔎  Toggle\n󰓦  Restart") in
          *Reminder*) show_reminder_menu ;;
          *Capture*) show_capture_menu ;;
          *Transcode*) leenix-transcode || back_to show_trigger_menu ;;
          *Share*) show_share_menu ;;
          *Toggle*) show_toggle_menu ;;
          *Restart*) show_restart_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_restart_menu() {
          case $(menu "Restart" "  Hypridle\n  Hyprsunset\n󰎟  Mako\n  SwayOSD\n󰌧  Walker\n󰍜  Waybar\n󰍜  PipeWire\n󰱾  WiFi\n󰂯  Bluetooth\n󰟸  Trackpad") in
          *Hypridle*) leenix-restart-hypridle ;;
          *Hyprsunset*) leenix-restart-hyprsunset ;;
          *Mako*) leenix-restart-mako ;;
          *SwayOSD*) leenix-restart-swayosd ;;
          *Walker*) leenix-restart-walker ;;
          *Waybar*) leenix-restart-waybar ;;
          *PipeWire*) leenix-restart-pipewire ;;
          *WiFi*) leenix-restart-wifi ;;
          *Bluetooth*) leenix-restart-bluetooth ;;
          *Trackpad*) leenix-restart-trackpad ;;
          *) back_to show_trigger_menu ;;
          esac
        }

        show_reminder_menu() {
          case $(menu "Reminder" "󰔛  Set one\n󰔛  Show all\n󰔛  Clear all") in
          *Set*) show_custom_reminder_input ;;
          *"Show all"*) leenix-reminder show ;;
          *"Clear all"*) leenix-reminder clear ;;
          *) back_to show_trigger_menu ;;
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

        show_capture_menu() {
          case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰴑  Text Extraction\n󰃉  Color") in
          *Screenshot*) leenix-capture-screenshot ;;
          *Screenrecord*) show_screenrecord_menu ;;
          *Text*) leenix-capture-text-extraction ;;
          *Color*) pkill hyprpicker || hyprpicker -a ;;
          *) back_to show_trigger_menu ;;
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

        show_share_menu() {
          case $(menu "Share" "  Clipboard\n  File \n  Folder") in
          *Clipboard*) leenix-menu-share clipboard ;;
          *File*) terminal bash -c "leenix-menu-share file" ;;
          *Folder*) terminal bash -c "leenix-menu-share folder" ;;
          *) back_to show_trigger_menu ;;
          esac
        }

        show_toggle_menu() {
          local options="󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰂛  Notifications\n󰍜  Top Bar\n󱂬  Workspace Layout\n  Window Gaps\n  1-Window Ratio\n󰍹  Monitor Scaling"

          case $(menu "Toggle" "$options") in
          *Screensaver*) leenix-toggle-screensaver ;;
          *Nightlight*) leenix-toggle-nightlight ;;
          *Idle*) leenix-toggle-idle ;;
          *Notifications*) leenix-toggle-notification-silencing ;;
          *Bar*) leenix-toggle-waybar ;;
          *Layout*) leenix-hyprland-workspace-layout-toggle ;;
          *Ratio*) leenix-hyprland-window-single-square-aspect-toggle ;;
          *Gaps*) leenix-hyprland-window-gaps-toggle ;;
          *Scaling*) leenix-hyprland-monitor-scaling-cycle ;;
          *) back_to show_trigger_menu ;;
          esac
        }

        show_hardware_menu() {
          local lap_action="Disable Laptop Monitor"
          [[ $(leenix-monitor-laptop status 2>/dev/null | sed -n 's/^desired: //p') == "disabled" ]] && lap_action="Enable Laptop Monitor"
          local options="󰛧  $lap_action\n󰍹  Mirror Display\n󰍹  Audio"

          if leenix-hw-hybrid-gpu; then
            options="$options\n  Hybrid GPU"
          fi

          if leenix-hw-touchpad; then
            options="$options\n󰟸  Touchpad"
          fi

          if leenix-hw-dell-xps-haptic-touchpad && leenix-cmd-present dell-xps-touchpad-haptics; then
            options="$options\n󰌌  Touchpad Haptics"
          fi

          if leenix-hw-touchscreen; then
            options="$options\n󰆽  Touchscreen"
          fi

          case $(menu "Hardware" "$options") in
          *Disable*Laptop*) leenix-monitor-laptop disable ;;
          *Enable*Laptop*) leenix-monitor-laptop enable ;;
          *Mirror*) leenix-hyprland-monitor-internal-mirror toggle ;;
          *Audio*) leenix-launch-audio ;;
          *Haptics*) show_hardware_touchpad_haptics_menu ;;
          *Touchpad*) leenix-toggle-touchpad ;;
          *Touchscreen*) leenix-toggle-touchscreen ;;
          *"Hybrid GPU"*) present_terminal leenix-toggle-hybrid-gpu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_hardware_touchpad_haptics_menu() {
          local current=$(dell-xps-touchpad-haptics get)
          local selected=$(menu "Touchpad Haptics" "low\nmid\nhigh" "" "$current")

          if [[ -n $selected ]]; then
            dell-xps-touchpad-haptics set "$selected"
          else
            back_to show_hardware_menu
          fi
        }

        show_network_menu() {
          case $(menu "Network" "󰇫  DNS\n  WiFi\n󰂯  Bluetooth") in
          *DNS*) leenix-config-dns ;;
          *WiFi*) leenix-launch-wifi ;;
          *Bluetooth*) leenix-launch-bluetooth ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_locale_menu() {
          case $(menu "Locale" "󰥔  Timezone\n󰧑  Language\n󰍛  Region & Formats") in
          *Timezone*) leenix-config-timezone ;;
          *Language*) leenix-config-language language ;;
          *Region*) leenix-config-language region ;;
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
            *) back_to show_main_menu ;;
          esac
        }

        show_setup_menu() {
          case $(menu "Setup" "󱐋  Power Profile\n󰒲  System Sleep\n󰈷  Defaults") in
          *Power*) show_setup_power_menu ;;
          *Sleep*) show_setup_system_menu ;;
          *Defaults*) show_setup_default_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_setup_power_menu() {
          profile=$(menu "Power Profile" "$(leenix-powerprofiles-list)" "" "$(powerprofilesctl get)")

          if [[ $profile == "CNCLD" || -z $profile ]]; then
            back_to show_setup_menu
          else
            powerprofilesctl set "$profile"
          fi
        }

        show_setup_default_menu() {
          case $(menu "Default" "  Terminal\n  Editor") in
          *Terminal*) show_setup_default_terminal_menu ;;
          *Editor*) show_setup_default_editor_menu ;;
          *) show_setup_menu ;;
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
          *) show_setup_default_menu ;;
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
          *) show_setup_default_menu ;;
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

          case $(menu "System" "$options") in
          *Suspend*) leenix-toggle-suspend ;;
          *"Enable Hibernate"*) present_terminal leenix-hibernation-setup ;;
          *"Disable Hibernate"*) present_terminal leenix-hibernation-remove ;;
          *) show_setup_menu ;;
          esac
        }

        show_update_menu() {
          case $(menu "Update" "  Update LEENIX\n󰜉  Rebuild LEENIX") in
          *Update*LEENIX*) present_terminal leenix-update ;;
          *Rebuild*LEENIX*) present_terminal leenix-rebuild ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_system_menu() {
          local options="󱄄  Screensaver\n  Lock"
          ! leenix-toggle-enabled suspend-off && options="$options\n󰒲  Suspend"
          leenix-hibernation-available && options="$options\n󰤁  Hibernate"
          options="$options\n󰍃  Logout\n󰜉  Restart\n󰐥  Shutdown"

          case $(menu "System" "$options") in
          *Screensaver*) leenix-launch-screensaver force ;;
          *Lock*) leenix-system-lock ;;
          *Suspend*) systemctl suspend ;;
          *Hibernate*) systemctl hibernate ;;
          *Logout*) leenix-system-logout ;;
          *Restart*) leenix-system-reboot ;;
          *Shutdown*) leenix-system-shutdown ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_main_menu() {
          go_to_menu "$(menu "Go" "󰀻  Background\n󰛧  Hardware\n󰇫  Network\n󰂻  Locale\n󰓦  Triggers\n  Setup\n  Update\n  System\n  About")"
        }

        go_to_menu() {
          case "''${1,,}" in
          *background*) show_background_menu ;;
          *hardware*) show_hardware_menu ;;
          *network*) show_network_menu ;;
          *locale*) show_locale_menu ;;
          *trigger*) show_trigger_menu ;;
          *toggle*) show_toggle_menu ;;
          *restart*) show_restart_menu ;;
          *reminder*) show_reminder_menu ;;
          *capture*) show_capture_menu ;;
          *share*) show_share_menu ;;
          *screenrecord*) show_screenrecord_menu ;;
          *setup*) show_setup_menu ;;
          *power*) show_setup_power_menu ;;
          *update*) show_update_menu ;;
          *system*) show_system_menu ;;
          *about*) leenix-launch-about ;;
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
